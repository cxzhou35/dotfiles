local opt = vim.opt
local wo = vim.wo
local g = vim.g
local o = vim.o

g.mapleader = " "
g.maplocalleader = " "

-- General
opt.confirm = true
opt.autowrite = true
opt.autoread = true
opt.iskeyword:append("-")
opt.backspace = { "start", "eol", "indent" }
opt.completeopt = "menu,menuone,noselect"
opt.wildmenu = true
opt.wildmode = "longest:list,full"
opt.laststatus = 3
opt.conceallevel = 2
opt.syntax = "off"
opt.confirm = true
o.ttyfast = true
o.scrolloff = 10
g.deprecation_warnings = false

-- Window
opt.title = true
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"

-- Backup
o.backup = false
o.writebackup = false
o.swapfile = false
opt.undofile = false

-- UI
o.showtabline = 0
wo.colorcolumn = "100"
opt.cmdheight = 0
opt.wrap = false
opt.showcmd = false
opt.showmode = false
opt.cursorline = true
opt.ruler = false
opt.number = true
opt.linebreak = true
opt.relativenumber = true

-- Clipboard
-- opt.clipboard = { "unnamed", "unnamedplus" }
opt.clipboard = "unnamedplus"

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.infercase = true
opt.hlsearch = false

-- Chars
opt.list = true
opt.listchars = {
  extends = "❯",
  precedes = "❮",
  trail = "·",
  tab = "» ",
  nbsp = "+",
  -- space = "·",
  -- eol = "↴",
}

o.foldenable = false
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- Match
-- https://vi.stackexchange.com/a/5318/12823
g.matchparen_timeout = 2
g.matchparen_insert_timeout = 2

-- Spell
-- Loading slowly
opt.spell = false
opt.spelllang = { "en" }

-- Tab & Indent
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.autoindent = true
opt.smartindent = true
opt.breakindent = true
opt.expandtab = true
opt.smarttab = true
opt.shiftround = true
opt.signcolumn = "yes"
opt.inccommand = "split"

-- Encoding
vim.scriptencoding = "utf-8"
opt.encoding = "utf-8"
opt.fileencodings = { "utf-8", "gbk", "gb2312" }
-- opt.termencoding = "utf-8"

-- Color
o.pumblend = 0
o.winblend = 0
o.cursorlineopt = "number"
opt.termguicolors = true

-- Add asterisks in block comments
opt.formatoptions:append({ "r" })

-- Wildfire
g.wildfire_objects = { "i'", 'i"', "i)", "i]", "i}", "ip", "it", "i`", "i*" }
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

-- Lazyvim
g.lazyvim_picker = "auto"
g.lazyvim_cmp = "auto"

-- Disable nvim intro
opt.shortmess:append("sI")

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
