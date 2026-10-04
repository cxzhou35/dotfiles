local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Neovim already detects .tex, .bbl and .bib. These extensions need an override.
vim.filetype.add({
  extension = {
    cls = "tex",
    texb = "tex",
    texx = "tex",
  },
})

-- Disable automatic comment continuation per buffer.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("format_options"),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Turn off paste mode when leaving insert mode.
vim.api.nvim_create_autocmd("InsertLeave", {
  group = augroup("disable_paste"),
  callback = function()
    vim.opt.paste = false
  end,
})

-- Show cursor line only in the active window.
local cursorline_group = augroup("active_cursorline")
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  group = cursorline_group,
  callback = function()
    local ok, cursorline = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
    if ok and cursorline then
      vim.wo.cursorline = true
      vim.api.nvim_win_del_var(0, "auto-cursorline")
    end
  end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  group = cursorline_group,
  callback = function()
    if vim.wo.cursorline then
      vim.api.nvim_win_set_var(0, "auto-cursorline", true)
      vim.wo.cursorline = false
    end
  end,
})

-- Disable foldcolumn and statuscolumn in Lspsaga outline.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("lspsaga_outline"),
  pattern = "sagaoutline",
  callback = function()
    vim.opt_local.foldcolumn = "0"
    vim.opt_local.statuscolumn = ""
  end,
})

-- Override LazyVim's text defaults with the preferred local behavior.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("text_overrides"),
  pattern = { "tex", "gitcommit", "markdown", "pandoc" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = false
    vim.opt_local.colorcolumn = "120"
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("two_space_indent"),
  pattern = { "scheme", "lisp", "racket", "yaml", "json", "jsonc" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("disable_markdown_autoformat"),
  pattern = "markdown",
  callback = function()
    vim.b.autoformat = false
  end,
})

-- Throttle LSP progress updates so chatty servers do not redraw notifications
-- for every individual progress event.
---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
---@type table<number, boolean>
local progress_scheduled = {}

vim.api.nvim_create_autocmd("LspProgress", {
  group = augroup("lsp_progress"),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local value = event.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end

    local client_progress = progress[client.id]
    for i = 1, #client_progress + 1 do
      if i == #client_progress + 1 or client_progress[i].token == event.data.params.token then
        client_progress[i] = {
          token = event.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    if progress_scheduled[client.id] then
      return
    end
    progress_scheduled[client.id] = true

    vim.defer_fn(function()
      progress_scheduled[client.id] = nil
      local messages = {} ---@type string[]
      progress[client.id] = vim.tbl_filter(function(item)
        table.insert(messages, item.msg)
        return not item.done
      end, progress[client.id])

      local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
      vim.notify(table.concat(messages, "\n"), vim.log.levels.INFO, {
        id = "lsp_progress",
        title = client.name,
        opts = function(notification)
          notification.icon = #progress[client.id] == 0 and " "
            or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
        end,
      })
    end, 80)
  end,
})
