<!-- markdownlint-disable MD013 -->

# Neovim 配置性能与维护性审计

> 审计日期：2026-10-02  
> Neovim：0.12.5  
> 配置基础：LazyVim + lazy.nvim  
> 2026-10-02 已完成优先级 item 1–14；按要求暂不修改 Dashboard。实施结果见第 10 节。
> 本文前 14 节保留各阶段的历史基线和当时的建议；当前状态见第 15 节。

## 1. 摘要

当前配置不属于整体启动缓慢，但存在几个明显的加载尖峰、重复功能和已经失效的配置。

最优先处理的问题是：

1. `garbage-day.nvim` 在空白启动后的 `VeryLazy` 阶段提前拉起整套 LSP 和 Mason，造成首屏显示后的短暂卡顿。
2. Dashboard 每次空启动都会运行 `cmatrix` 和 `chafa` 等外部进程。
3. `lualine`、`bufferline`、`incline`、`nvim-scrollbar` 等 UI 插件叠加，增加启动和持续刷新成本。
4. Python LSP、Neo-tree、CopilotChat、Treesitter、mini.hipatterns 等配置存在拼写错误、配置层级错误或 API 漂移。
5. Telescope、Neo-tree、多个 Telescope 扩展与已经常驻的 Snacks 存在较大的功能重叠。
6. `lazy-lock.json` 没有纳入 Git，导致配置无法在新机器上稳定复现。

预计先完成低风险优化后：

- 空启动首屏可减少约 20–35 ms。
- 可以消除首屏显示之后约 60 ms 的 LSP 加载卡顿。
- 打开代码文件时还能减少一部分无关插件和重复 UI 的加载时间。

这些估算需要在修改后重新 profile 验证，不能直接视为最终收益。

## 2. Profile 方法和结果

本次使用了以下方式交叉检查：

- Neovim `--startuptime`
- lazy.nvim 插件加载统计
- 真实 TUI 启动，而不只是 `--headless`
- 空启动、打开 Lua 文件、首次进入 Insert 三种场景
- `:checkhealth`
- 运行态检查插件实际合并后的配置

lazy.nvim 的插件耗时可能包含依赖加载时间，因此下列插件耗时不能直接相加，主要用于识别加载链条和相对热点。

### 2.1 启动时间

| 场景 | 结果 |
| --- | ---: |
| 真实 TUI 空启动，5 次 | 101–122 ms，中位约 110 ms |
| 打开 Lua 文件，3 次 | 199–223 ms，中位约 212 ms |
| 空启动 300 ms 后 | 已加载 28/69 个插件 |
| Lua 文件 300 ms 后 | 已加载 36/69 个插件 |
| 首次进入 Insert | `blink.cmp` 约 21 ms |

`--startuptime` 在首屏绘制完成时结束，无法反映随后触发的 `VeryLazy` 工作。因此空启动虽然约 110 ms 显示首屏，之后仍可能发生明显的同步加载。

### 2.2 空启动后的主要加载项

在真实 TUI 空启动 300 ms 后，主要包容耗时如下：

| 插件 | 约耗时 | 说明 |
| --- | ---: | --- |
| `garbage-day.nvim` | 60 ms | 包含其 LSP 依赖链 |
| `nvim-lspconfig` | 59 ms | 被 `garbage-day.nvim` 提前拉起 |
| `mason.nvim` | 25 ms | 随 LSP 配置加载 |
| `lualine.nvim` | 21 ms | 包含配置和相关组件 |
| `catppuccin` | 11 ms | 集成检测占主要部分 |
| `mini.surround` | 7 ms | 空启动即加载 |
| `bufferline.nvim` | 6 ms | `VeryLazy` 阶段加载 |
| `nvim-scrollbar` | 4 ms | 空启动即加载 |
| `flash.nvim` | 4 ms | `VeryLazy` 阶段加载 |
| `noice.nvim` | 4 ms | `VeryLazy` 阶段加载 |

### 2.3 打开 Lua 文件后的主要加载项

| 插件 | 约耗时 | 说明 |
| --- | ---: | --- |
| `nvim-lspconfig` | 58 ms | 包含 LSP 配置链 |
| `mason.nvim` | 30 ms | 包管理和 registry 初始化 |
| `lualine.nvim` | 26 ms | 状态栏组件较多 |
| `catppuccin` | 11 ms | 颜色和插件集成 |
| `copilot.lua` | 9 ms | 每个普通文件在 `BufReadPost` 加载 |
| `lspsaga.nvim` | 8 ms | `LspAttach` 时加载 |
| `mini.surround` | 8 ms | 与另一套 surround 并存 |
| `nvim-treesitter` | 7 ms | 语法树和 parser 初始化 |
| `nvim-scrollbar` | 5–6 ms | 同时维护诊断和 Git 标记 |
| `bufferline.nvim` | 5–6 ms | UI 组件 |
| `incline.nvim` | 5 ms | 每次打开普通文件加载 |

### 2.4 首次进入 Insert

| 插件 | 约耗时 |
| --- | ---: |
| `blink.cmp` | 21 ms |
| `better-escape.nvim` | 3 ms |

`blink.cmp` 是当前维护良好且以性能为重点的补全方案。虽然首次插入有可见加载成本，但不建议因此换回 `nvim-cmp`。

## 3. 高优先级性能问题

### 3.1 `garbage-day.nvim` 提前加载 LSP

位置：[lua/plugins/code/lsp.lua](lua/plugins/code/lsp.lua#L87)

```lua
{
  "zeioth/garbage-day.nvim",
  dependencies = "neovim/nvim-lspconfig",
  event = "VeryLazy",
}
```

在 Dashboard 等不需要 LSP 的场景中，这个声明仍会加载 `nvim-lspconfig` 和 Mason。它是目前最明显的首屏后卡顿来源。

候选方案：

- 如果平时不会频繁跨大型项目复用同一个 Neovim 实例，直接移除。
- 如果确实需要自动停止闲置 LSP，改为在真正发生 LSP 活动后初始化。
- 修改后分别 profile 空启动和多项目切换，确认收益与功能取舍。

### 3.2 Dashboard 启动外部进程

位置：[lua/plugins/ui/dashboard.lua](lua/plugins/ui/dashboard.lua#L88)

当前空启动会运行：

- `cmatrix`
- `chafa`
- 动态图片渲染
- `sleep`
- 硬编码的本机图片路径

UIEnter 阶段实测约 18–24 ms，外部进程还会在首屏绘制后继续工作。

候选方案：

- 默认只保留静态 header 和快捷键。
- 动画图片改为显式命令或按键触发。
- 使用基于配置目录或环境变量的可移植图片路径。
- 如果保留动画，应在终端能力和文件存在时才运行。

### 3.3 UI 插件叠加

当前同时存在：

- `lualine.nvim`
- `bufferline.nvim`
- `incline.nvim`
- `nvim-scrollbar`
- Snacks statuscolumn、scroll、scope、indent
- Noice

其中 `lualine`、`bufferline`、`incline` 都展示文件或窗口状态。建议保留 `lualine`，再在 `bufferline` 和 `incline` 中二选一。

`nvim-scrollbar` 还监听 `TextChanged`、`WinScrolled`、诊断和 Gitsigns，属于持续运行成本，而不只是启动成本。参见 [lua/plugins/ui/scroll.lua](lua/plugins/ui/scroll.lua#L132)。

### 3.4 Catppuccin 集成检测

位置：[lua/plugins/colorscheme/catppuccin.lua](lua/plugins/colorscheme/catppuccin.lua#L33)

`catppuccin.lib.detect_integrations` 单次约 6–11 ms。当前配置还声明了多个已经禁用或不存在的集成：

- `cmp`
- `alpha`
- `hop`
- `neogit`
- `notify`
- `ts_rainbow`

候选方案是关闭自动检测，并只启用实际使用的集成。

### 3.5 全局懒加载策略

位置：[lua/config/lazy.lua](lua/config/lazy.lua#L40)

```lua
defaults = {
  lazy = false,
  version = false,
}
```

初始审计时，`defaults.lazy = false` 会使所有缺少明确加载条件的插件默认常驻；当时受影响的插件包括 `vimtex`、`wildfire`、`nvim-scrollbar`、`mini.surround` 等。

不建议立刻机械地改成 `true`。应先保证每个插件都有正确的 `event`、`cmd`、`ft` 或 `keys`，再切换默认策略并逐项测试。

## 4. 已确认需要更新的配置

### 4.1 Python LSP 字段拼写错误

位置：[lua/plugins/lang/python.lua](lua/plugins/lang/python.lua#L23)

当前字段：

```lua
root_makers = { ... }
```

正确字段应为：

```lua
root_markers = { ... }
```

当前设置会被静默忽略。

### 4.2 Neo-tree 配置层级错误

位置：[lua/plugins/editor/explorer.lua](lua/plugins/editor/explorer.lua#L109)

存在两个问题：

1. `event_handlers` 被放在 `default_component_configs` 内，而不是 Neo-tree 顶层配置。
2. 用于 Snacks rename 的 `opts = function` 被嵌套在 `opts` 表里，不会被 lazy.nvim 当作 spec 合并函数执行。

运行态检查确认顶层 `event_handlers` 为 `nil`，因此以下预期行为没有正确注册：

- 打开文件后自动关闭 Neo-tree
- 打开或关闭侧栏后平衡窗口
- 文件移动或重命名后通知 Snacks/LSP

### 4.3 CopilotChat API 漂移

位置：[lua/plugins/code/copilot.lua](lua/plugins/code/copilot.lua#L29)

已经确认的问题：

- `context = { "buffers" }` 已不是当前资源配置方式。
- `agent = "copilot"` 不属于当前配置字段。
- `CopilotChatAgents` 命令不存在。
- `CopilotChatRefactor` 命令不存在。
- `CopilotChatBetterNamings` 命令不存在。
- 固定 `claude-3.7-sonnet-thought` 容易因账户或服务端模型变化失效。
- `build = ":Copilot auth"` 会在插件安装或更新阶段运行认证和下载流程。

当前版本应改用 resources、模型选择器和现有 prompts。参考 [CopilotChat.nvim 文档](https://github.com/CopilotC-Nvim/CopilotChat.nvim)。

### 4.4 Treesitter 旧配置已经失效

位置：[lua/plugins/code/treesitter.lua](lua/plugins/code/treesitter.lua#L10)

当前 `nvim-treesitter` main 分支已不再使用旧模块配置方式。以下字段没有按预期工作：

- `query_linter`
- `incremental_selection`
- `autotag`

运行态检查确认 `<M-enter>` 和 visual `<BS>` 都没有生成配置中的增量选择映射。

同时 `:checkhealth` 报告缺少 `tree-sitter` CLI；当前 main 分支安装或更新 parser 需要它。参考 [nvim-treesitter requirements](https://github.com/nvim-treesitter/nvim-treesitter#requirements)。

本机还同时存在两份 parser：

- `~/.local/share/nvim/treesitter`：约 19 MB
- `~/.local/share/nvim/site/parser`：约 18 MB

后续应先确认新目录中的 parser 工作正常，再清理旧目录。

### 4.5 `mini.hipatterns` 配置不完整

位置：[lua/plugins/utils/lazyvim.lua](lua/plugins/utils/lazyvim.lua#L1)

这段代码来自旧版 LazyVim extra，但缺少原模块里的 `local M` 和 Tailwind 色表，同时引用了：

```lua
M.hl
M.colors
```

运行态看到 `mini.hipatterns` 的 `highlighters` 为空，说明这份配置没有按预期生效。

建议删除本地复制版本，改为启用当前 LazyVim 官方的 `mini-hipatterns` extra。

### 4.6 Snacks 仓库名拼写错误

位置：[lua/plugins/editor/zenmode.lua](lua/plugins/editor/zenmode.lua#L1)

当前写成：

```lua
"floke/snacks.nvim"
```

应为：

```lua
"folke/snacks.nvim"
```

目前因为插件名相同且存在其他正确的 Snacks spec，最终碰巧合并到了正确仓库，但不应依赖这种行为。

### 4.7 自动同步插件的 autocmd 不生效

位置：[lua/config/autocmds.lua](lua/config/autocmds.lua#L123)

当前 pattern 是插件目录本身，没有匹配目录内的 Lua 文件，因此基本不会触发。

即使修复 pattern，也不建议每次保存插件配置都自动执行完整 `Lazy sync`。更合适的方式是显式运行 `:Lazy sync`，或只触发 change detection/check。

### 4.8 Clangd 日志级别过高

位置：[lua/plugins/lang/cpp.lua](lua/plugins/lang/cpp.lua#L65)

当前长期启用：

```text
--log=verbose
```

这会增加持续磁盘 IO。目前 Neovim LSP 日志约 2.9 MB。正常使用时建议移除，只在诊断 clangd 问题时临时开启。

### 4.9 本地选项使用了全局写法

[lua/config/autocmds.lua](lua/config/autocmds.lua) 中部分 FileType autocmd 使用了 `vim.opt` 或 `vim.wo`，而不是 `vim.opt_local`。例如：

- JSON conceallevel
- Markdown/TeX tabstop、shiftwidth、softtabstop

这可能把某个文件类型的设置传播到后续 buffer，应统一为局部选项。

## 5. 重复插件和功能整合

### 5.1 Surround

位置：[lua/plugins/editor/surround.lua](lua/plugins/editor/surround.lua)

同时安装了：

- `nvim-mini/mini.surround`
- `kylechui/nvim-surround`

建议二选一。当前配置已经为 `mini.surround` 设置了完整的 `m` 前缀映射，优先保留它更容易减少改动。

### 5.2 Picker 和文件浏览器

当前有：

- Telescope
- telescope-file-browser
- telescope-live-grep-args
- telescope-symbols
- telescope-undo
- telescope-fzf-native
- Neo-tree
- TFM/Yazi
- Snacks，但 picker 被禁用

已经安装的 Snacks picker/explorer 可以覆盖：

- 文件查找
- grep 和参数过滤
- buffer
- undo 历史
- symbols
- diagnostics
- colorscheme
- 文件树
- Git 状态和 diff

参考 [Snacks picker 文档](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md)。

迁移到 Snacks 的主要收益是减少配置和插件数量。由于 Telescope 和 Neo-tree 当前本身已经懒加载，这一迁移对首屏时间的改善可能有限，更多是维护性和功能整合收益。

### 5.3 结构化选择

`wildfire.vim` 已归档，并已从当前配置移除。结构化选择统一使用 Flash 的 Treesitter 官方接口，文本对象继续由 `mini.ai` 和 Neovim 内置 text objects 提供。参考 [wildfire.vim](https://github.com/gcmt/wildfire.vim)。

候选方案：

- 使用 `mini.ai` 和 Neovim 内置 text objects。
- Treesitter 增量选择交给 Flash 官方接口，不再维护本地 node range/selection stack 实现。

### 5.4 Python 环境

`nvim-conda` 的快捷键长期处于注释状态，且打开 Python 文件时仍会加载，因此已移除；当前 Python 环境继续由启动 Neovim 时继承的环境和 basedpyright 处理。

后续如果需要在单个 Neovim 会话中切换虚拟环境，可以再引入 [venv-selector.nvim](https://github.com/linux-cultist/venv-selector.nvim)，它支持：

- Conda/Miniconda
- Poetry
- Pyenv
- 普通 venv
- 项目级环境记忆
- 更新 LSP 和终端环境

这也是当前 LazyVim Python extra 使用的方案。

### 5.5 Markdown 图片

`clipboard-image.nvim` 已替换为 [img-clip.nvim](https://github.com/HakonHarnes/img-clip.nvim)，继续使用 `<leader>ri`，并按当前 API 配置 Markdown 与 LaTeX 模板。插件只在执行图片命令时加载。

### 5.6 Yazi 集成

`tfm.nvim` 已替换为 [yazi.nvim](https://github.com/mikavilpas/yazi.nvim) v14.0.2，继续使用 `;y`。Yazi 保持按键触发加载，并关闭目录劫持以避免与保留的 Neo-tree 冲突。

### 5.7 URL 打开

Neovim 0.12 已提供 `vim.ui.open`，且 `:checkhealth` 确认系统存在可用的 `open` handler。`url-open` 可以由一个简单的 `gx` 映射替代。

### 5.8 图标搜索

`nerdicons.nvim` 当前仍可用。如果希望换成维护更活跃的图标搜索器，可以考虑 [nerdy.nvim](https://github.com/2KAbhishek/nerdy.nvim)。这不是性能优先项。

### 5.9 C/C++ 扩展

`clangd_extensions.nvim` 仍在维护，但当前配置会在非 C/C++ 文件的 LSP 配置阶段引用它。

如果只使用 source/header 切换、inlay hints 等原生 clangd 已支持的功能，可以考虑移除；如果会使用 AST、memory usage、symbol info 等扩展功能，则应保留但确保只在 C/C++ 文件加载。

## 6. 插件管理与可复现性

### 6.1 Lockfile 已纳入 Git

根目录 `.gitignore` 现在只继续忽略本机生成的 `lazyvim.json`，不再忽略 `lazy-lock.json`：

```gitignore
nvim/lazyvim.json
```

`lazy-lock.json` 已成为待提交文件，新机器可以复现本轮验证过的插件提交。`lazyvim.json` 仍按本机 Extras 状态处理。

### 6.2 自动更新检查

位置：[lua/config/lazy.lua](lua/config/lazy.lua#L45)

当前每个检查周期会对约 69 个插件执行 Git fetch。实测这会增加网络和退出时间波动。

候选方案：

- 禁用自动 checker，手动执行 `:Lazy check`。
- 或提高检查间隔，例如每天一次。
- 状态栏不再常驻更新数量组件。

### 6.3 禁用插件残留

已删除 hardtime、smear-cursor、Neogit、nvim-cmp、nvim-notify 和 modicator 的重复个人配置，并执行 `:Lazy clean` 清理不再引用的安装目录。`disabled.lua` 只保留用于关闭 LazyVim 默认插件的声明。

## 7. Health Check 结果

### 正常项

- Neovim 0.12.5 Release build
- `vim.deprecated` 未检测到 deprecated API
- Mason 2 和 mason-lspconfig 工作正常
- LSP 基础健康检查通过
- 已安装 parser 可以正常识别

### 需要处理

- 缺少 `tree-sitter` CLI。
- Python `pynvim` 为 0.4.3，当前检查提示可升级到 0.6.0。
- Node、Perl、Ruby provider 未安装。
- 存在旧的 `site/pack/core` 目录。
- Snacks input 已启用，但实际 `vim.ui.input` 被 Telescope 接管。
- Snacks picker 被禁用，但部分配置已经直接调用 `Snacks.picker.*`。

Node、Perl、Ruby provider 对当前以 Lua/Vimscript 为主的插件集不是必需项。与其安装所有 provider，更适合显式禁用确定不用的 provider。

## 8. 建议的实施顺序

### 阶段一：修复正确性，不改变主要交互

- [x] 修复 Python `root_markers`。
- [x] 修复 Neo-tree `event_handlers` 和 rename 回调层级。
- [x] 更新 CopilotChat 配置和失效快捷键。
- [x] 修复 Snacks 仓库名拼写。
- [x] 用当前 LazyVim extra 替换本地 `mini.hipatterns` 副本。
- [x] 更新 Treesitter 配置，移除失效模块字段。
- [x] 安装 `tree-sitter` CLI。
- [x] 移除 clangd verbose logging。
- [x] 修复 FileType autocmd 的局部选项。
- [x] 跟踪 `lazy-lock.json`。

### 阶段二：低风险性能优化

- [x] 移除 `garbage-day.nvim`。
- [x] Dashboard 按使用偏好保持现状。
- [x] 关闭 Catppuccin 无关集成和自动检测。
- [x] 在 `mini.surround` 与 `nvim-surround` 中二选一。
- [x] Bufferline 与 Incline 按使用偏好同时保留。
- [x] 评估是否保留 `nvim-scrollbar`；当前继续保留。
- [x] 关闭 lazy.nvim 自动更新检查，改为手动执行 `:Lazy check`。
- [x] 清理已经禁用插件的重复配置和安装残留。

### 阶段三：插件体系整合

- [ ] 试用 Snacks picker 替代 Telescope 及其扩展。
- [ ] 试用 Snacks explorer 替代 Neo-tree。
- [x] 移除没有实际快捷键和使用入口的 `nvim-conda`。
- [x] 用 `img-clip.nvim` 替代 `clipboard-image.nvim`。
- [x] 用 `yazi.nvim` 替代 TFM。
- [x] 用 `vim.ui.open` 替代 `url-open`。
- [x] 重新设计结构化选择，移除已归档的 Wildfire。

### 阶段四：默认懒加载

- [x] 为仍保留的插件补齐明确加载条件。
- [x] 将 `defaults.lazy` 改为 `true`。
- [x] 分别测试 Dashboard、普通代码文件、Markdown、TeX、Python、TypeScript、C/C++。
- [x] 重新执行启动和运行时 profile。

## 9. 验收指标

优化后建议至少记录以下指标：

| 指标 | 当前基线 | 建议目标 |
| --- | ---: | ---: |
| 空启动首屏中位数 | 约 110 ms | 低于 90 ms |
| 空启动后 LSP 加载 | 约 60 ms | 不加载 |
| 打开 Lua 文件中位数 | 约 212 ms | 低于 180 ms |
| 空启动 300 ms 后插件数 | 28/69 | 明显减少 |
| 首次进入 Insert | Blink 约 21 ms | 保持或小幅改善 |
| `:checkhealth` | 1 个 TS CLI 错误 | 无必要错误 |

还应手动验证：

- LSP、补全和 Copilot 是否能正常启动。
- Python 环境切换是否正确更新 LSP。
- C/C++ root detection 和 clangd source/header 切换是否正常。
- Markdown 图片粘贴、预览和渲染是否正常。
- TeX inverse search 和自动编译是否正常。
- 文件移动或重命名后 LSP import 是否同步更新。
- Dashboard、picker、explorer 和终端的快捷键是否保持一致。

## 10. 本轮实施结果（item 1–14）

| Item | 优化内容 | 状态与结果 |
| ---: | --- | --- |
| 1 | Python LSP 根目录字段 | 已将 `root_makers` 修正为 `root_markers`，运行态合并结果正确。 |
| 2 | Neo-tree 配置层级 | 已把事件处理器移到顶层；打开文件、窗口平衡以及 LazyVim 自带的 rename 通知可以同时生效。 |
| 3 | CopilotChat API | 已改用 `resources = "buffer:listed"`、当前 `headers` API 和默认模型；删除失效的 Agents/Naming 命令，将 Refactor 替换为现有 Optimize prompt。 |
| 4 | Treesitter | 已删除失效的旧模块字段；后续进一步删除本地 Treesitter 节点脚本，改由 Flash 官方接口实现 `<M-CR>` 扩选和 `<BS>` 缩选。 |
| 5 | mini.hipatterns | 已切换为当前 LazyVim 官方 extra；运行态可见 `hex_color`、`shorthand`，Tailwind 高亮由 extra 注入。 |
| 6 | Snacks 仓库名 | 已将 `floke/snacks.nvim` 修正为 `folke/snacks.nvim`。 |
| 7 | FileType 局部选项 | `formatoptions`、conceal、文本类 tab width 和 colorcolumn 均改为 `vim.opt_local`。 |
| 8 | 保存时 `Lazy sync` | 已删除无效且不应隐式执行完整同步的 autocmd。 |
| 9 | clangd 日志 | 已移除常驻的 `--log=verbose`。 |
| 10 | garbage-day | 已移除插件声明和本地锁文件条目，空启动不再拉起 LSP/Mason。 |
| 11 | Dashboard | 按要求暂不修改；文件 SHA-1 前后均为 `ebbb1616126c9fa1afc53948be6ad5ab84c7756e`。 |
| 12 | Catppuccin | 已关闭 `auto_integrations`，移除不存在或未使用的集成，并显式保留当前使用项。 |
| 13 | lazy.nvim 更新检查 | 已关闭后台 checker；需要时手动运行 `:Lazy check`。 |
| 14 | Lualine | 已移除未使用的 Conda/颜色代码、Profiler 状态和后台更新状态，LSP 状态只查询当前 buffer。 |

### 10.1 `garbage-day.nvim` 功能与实际使用频率判断

根据 [garbage-day.nvim 官方说明](https://github.com/Zeioth/garbage-day.nvim)，该插件会在 Neovim 失去焦点后开始计时；默认非 aggressive 模式下，连续失焦达到 15 分钟才停止 LSP client，以回收长时间运行、多项目会话中的内存。

原配置没有主动调用记录，也没有开启通知或日志，因此无法从历史数据得到精确触发次数。可以确定的是：它每次 `VeryLazy` 都会加载，而只有“Neovim 连续失焦 15 分钟且已有 LSP client”时才可能产生收益。对当前启动 profile 来说，这是低频收益、高频成本，所以本轮选择移除。若之后确实长期保持同一个多项目 Neovim 会话，可再改为首次 `LspAttach` 后加载，而不是恢复 `VeryLazy`。

### 10.2 修改后验证

- `tree-sitter-cli 0.27.0` 已通过 Homebrew 安装，并写入两份安装清单。
- `:checkhealth` 已确认 Treesitter CLI 可用，`vim.deprecated` 无问题。
- 空启动 300 ms 后由 28/69 个插件降为 23/68 个；LSP、Mason 和 `garbage-day.nvim` 均不再出现在空启动加载列表。
- Catppuccin 包容耗时由约 11.5 ms 降至多次测试约 5–8 ms。
- 空启动下 Lualine 多次测试约 23–25 ms；组件已简化，但本轮未观察到稳定的启动耗时下降。
- 打开 Lua 文件时 LSP 仍按需加载，CopilotChat 当前命令、Neo-tree 合并配置、mini.hipatterns 高亮器和 Treesitter 选择映射均通过运行态检查。
- 当前自动化 TUI 由伪终端承载，会额外产生约 115 ms 的终端能力查询等待，因此不把这组首屏总时间与真实 Ghostty 基线直接比较；最终体感测试应在真实终端中完成。

## 11. 当前建议

下一轮建议先完成 TeX、Python 的真实文件回归测试，再决定是否迁移到 Snacks picker/explorer、`venv-selector.nvim`、`img-clip.nvim` 和 `yazi.nvim`。Incline、Scrollbar 和 Dashboard 按当前使用偏好继续保留。

## 12. `lua/config` 与 LazyVim 默认配置整合

本轮重新启用了 LazyVim 默认 autocmd 和 keymap，并按“相同配置交给 LazyVim，冲突配置以个人设置为准”的规则整理 `lua/config`。

### 12.1 已完成

- `options.lua` 删除了 LazyVim 已设置的重复项，只保留个人差异；`scrolloff = 10`、`expandtab = false`、`inccommand = "split"`、`pumblend = 0`、`foldenable = false`、`undofile = false` 等仍由个人配置覆盖。
- 删除无效的 `showtabline = 0`。运行时实际由 Bufferline 设置为 `2`，原配置从未生效。
- `autocmds.lua` 使用独立 augroup 和局部选项；高亮复制、检查外部文件变化、JSON conceal、关闭临时窗口、自动创建目录等重复逻辑改由 LazyVim 提供。
- 个人文本设置改用独立 `lazyvim_text_overrides` 组，不再清空 LazyVim 对 `text`、`plaintex`、`typst` 的默认处理。
- `.cls`、`.texx`、`.texb` 注册为 `tex`；不再错误地把 `.bib` 强制设为 `tex`，其文件类型恢复为 `bib`。
- LSP progress 通知增加 80 ms 合并窗口，减少高频进度事件导致的重复刷新。
- `defaults.lazy` 已切换为 `true`，并为 vim-repeat、mini.surround、scrollbar 和 copilot-lualine 补充明确加载事件；Wildfire 后续已移除。
- 个人 keymap 文件保持原样，仅按确认移除 `<C-m> -> %`；该键不再由个人配置占用，交回默认行为。LSP buffer 中显式保留个人的 `K -> 5k`，hover 继续使用 `<leader>k`。
- Markdown Preview 只重新触发自己的 `mkdp_init` autocmd，不再主动重放全部 `FileType` autocmd。
- `colors.lua`、`icons.lua` 和 Dashboard 均未修改。

### 12.2 验证结果

- 真实 TUI 运行态确认 LazyVim 默认 autocmd/keymap 已启用，个人冲突项最终值正确。
- Markdown、text、plaintex、JSON、Lua 的 wrap、spell、缩进、conceal、formatoptions 和 autoformat 均通过断言。
- 文件类型结果：`.tex/.bbl/.cls/.texx/.texb -> tex`，`.bib -> bib`。
- Lua 文件可连接 `lua_ls`，Markdown 可连接 `marksman`；Markdown Preview buffer command 正常生成。
- `:checkhealth lazyvim` 全部通过；`:checkhealth lazy` 只保留旧 `site/pack/core` 目录警告。
- 空启动 300 ms 后加载插件从上一轮 `23/68` 降到 `21/68`；最初基线为 `28/69`。
- 相同 headless 命令的 20 次热身后测试为 `84.1 ± 7.8 ms`；上一轮为 `100.6 ± 10.2 ms`，本轮降低约 `16.5 ms`（`16.4%`）。真实终端首屏仍建议以 Ghostty 内手动体感为准。

## 13. 插件去重与 C/C++ 配置更新

- 保留 `mini.surround` 及其个人 `m` 系列映射，移除重复的 `nvim-surround`。
- 移除 `url-open`；`gx` 继续使用 Neovim 0.12 默认映射，并由 `vim.ui.open` 调用系统处理程序。
- `clangd_extensions.nvim` 不再由全局 LSP 初始化提前 `require`，现在只在 C/C++ FileType 加载。
- 将 clangd 的旧 `root_dir(fname)` 回调更新为当前 `vim.lsp.config` 支持的 `root_markers`。旧回调在 Neovim 0.12 收到 buffer 编号时会报 `path: expected string, got number`。
- Incline 按要求保留。对比 `nvim-scrollview` 和 `satellite.nvim` 后，Scrollbar 暂时继续使用 `nvim-scrollbar`；现有配置已经具备按文件懒加载、100 ms 节流、诊断和 Git 标记。
- 删除约 90 行本地 Treesitter node range/selection stack 实现；增量选择改用 LazyVim 和 Flash 官方推荐的 `require("flash").treesitter()`，继续沿用 `<M-CR>` / `<BS>`。
- 运行态验证：Lua 文件不加载 clangd extensions，C++ 文件按需加载且相关命令可用；空启动 300 ms 后由 `21/68` 进一步降为 `20/66`。

## 14. LSP API 与插件替换收尾

- TypeScript LSP 从已移除的 `tsserver` 名称迁移到 `ts_ls`，保留原 inlay hints、Git root 和禁用单文件模式的个人设置；运行态已连接 `ts_ls`，不再产生无效配置错误。
- clangd 的参数更新为 `--function-arg-placeholders=true`；初始化前移除 clangd 23 已弃用的 `offsetEncoding` 扩展，改由 LSP 3.17 `positionEncodings` 协商，实际连接编码为 UTF-8。
- `clipboard-image.nvim` 替换为 `img-clip.nvim`，`<leader>ri` 不变；`tfm.nvim` 替换为 `yazi.nvim` v14.0.2，`;y` 不变。两者均保持按需加载。
- `:checkhealth img-clip yazi` 全部通过；本机已具备 `pngpaste`、Yazi 26.9.1、`ya` 和 `grealpath`。
- Dashboard 真实 TUI 可正常显示并退出，没有遗留外部进程；Lua、Markdown、Python、TeX、TypeScript、C++ 分别连接 `lua_ls`、`marksman`、`basedpyright`、`texlab`、`ts_ls`、`clangd`。
- 当前 Lazy spec 总数为 64；相同 headless 命令 20 次测试为 `68.8 ± 8.2 ms`，上一轮为 `84.1 ± 7.8 ms`。
- Telescope 和 Neo-tree 按要求暂不迁移，仍是剩余的两项插件体系整合候选。

## 15. 后续收尾（2026-10-04）

- Telescope 及其扩展已由 Snacks picker 替换；文件、grep、recent、Git、undo 和 Dashboard 入口均使用 Snacks。`<C-f>` 使用 Snacks explorer，Neo-tree 侧栏仍保留。
- Dashboard 不再启动 `cmatrix` 或 `chafa`，也不再依赖图片资源。WakaTime 在读取或创建文件后加载，不在 Dashboard 启动；Lualine 保持现状，colorful-winsep 关闭平滑动画。
- `clangd_extensions.nvim` 已移除，`<leader>ch` 改用原生 clangd 命令。CarbonNow 已移除，CodeSnap 保留。`img-clip.nvim` 和 `yazi.nvim` 替代原有图片粘贴及终端文件管理入口。
- Python provider 使用 `pynvim` 0.6.0；Node、Perl、Ruby provider 已禁用。`lazy-lock.json` 纳入版本管理，Tree-sitter CLI 已加入 Homebrew 安装清单。
- 本阶段的配置加载和格式检查已通过。伪终端中的空启动首屏约 94 ms；该环境的终端能力探测会干扰计时，不能与真实 Ghostty 基线直接比较。
