local opt = vim.opt
local g = vim.g

-- LazyVim defaults are loaded before this file. Keep only personal overrides.
g.maplocalleader = " "
g.python3_host_prog = "/opt/homebrew/bin/python3.11"
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- General
opt.iskeyword:append("-")
opt.wildmode = "longest:list,full"
opt.title = true
opt.scrolloff = 10

-- Persistence and recovery
opt.writebackup = false
opt.swapfile = false
opt.undofile = false

-- UI
opt.colorcolumn = "100"
opt.cmdheight = 0
opt.showcmd = false
opt.hlsearch = false
opt.infercase = true
opt.listchars = {
  extends = "❯",
  precedes = "❮",
  trail = "·",
  tab = "» ",
  nbsp = "+",
}
opt.foldenable = false

-- Tab and indent
opt.softtabstop = 2
opt.breakindent = true
opt.expandtab = false
opt.inccommand = "split"

-- File encoding fallback order
opt.fileencodings = { "utf-8", "gbk", "gb2312" }

-- Color and popup behavior
opt.pumblend = 0
opt.cursorlineopt = "number"

-- Ignore generated files in command-line completion.
opt.wildignorecase = true
opt.wildignore = {
  "*~",
  "*.o",
  "*.obj",
  "*.so",
  "*vim/backups*",
  "*.git/**",
  "**/.git/**",
  "*sass-cache*",
  "*DS_Store*",
  "vendor/rails/**",
  "vendor/cache/**",
  "*.gem",
  "*.pyc",
  "*.zip",
  "*.bg2",
  "*.gz",
  "*.db",
  "**/node_modules/**",
  "**/bin/**",
  "**/thesaurus/**",
  "*.aux",
  "*.out",
  "*.toc",
}

-- Keep LazyVim picker integrations on Snacks.
g.lazyvim_picker = "snacks"

-- Disable the intro and search-count messages.
opt.shortmess:append("s")
