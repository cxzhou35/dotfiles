local Util = require("lazyvim.util")
-- local map = Util.safe_keymap_set
local map = vim.keymap.set
local unmap = vim.keymap.del
local opts = { silent = true, noremap = true }

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Paste over currently selected text without yanking it
map("v", "p", '"_dP', { silent = true })
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy with register", silent = true })
map({ "n", "x" }, "<leader>p", '"0p', { desc = "Paste with register", silent = true })

-- Delete without yanking
map({ "n", "v" }, "<leader>d", [["_d]])

-- Jumplist
map({ "n", "x", "s" }, "<C-m>", "%", opts)

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Select all
map("n", "<leader>A", "gg<S-v>G", { desc = "Select all" })

-- Clear search and stop snippet on escape
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  LazyVim.cmp.actions.snippet_stop()
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Move cursor
map({ "n", "v", "o" }, "H", "^", { desc = "Jump to the start of line" })
map({ "n", "v", "o" }, "L", "g_", { desc = "Jump to the end of line" })

-- Quick moving between lines
-- map({ "n", "v", "o" }, "J", "5j", { desc = "Quick forward" })
-- map({ "n", "v", "o" }, "K", "5k", { desc = "Quick backward" })

-- Disable continuations
map("n", "<Leader>o", "o<Esc>^Da", opts)
map("n", "<Leader>O", "O<Esc>^Da", opts)

-- Switch buffers
if Util.has("bufferline.nvim") then
  map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
else
  map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
end
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Switch tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>h", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab>j", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>k", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>q", "<cmd>tabclose<cr>", { desc = "Close Tab" })

-- Split window
map("n", "s", "<Nop>")
map("n", "ss", "<cmd>split<Return><C-w>w", { silent = true, desc = "split" })
map("n", "sv", "<cmd>vsplit<Return><C-w>w", { silent = true, desc = "vsplit" })
map("n", "se", "<C-w>=", { desc = "Make splits equal size" })
map("n", "so", "<C-w>o", { desc = "Close all other windows" })
map("n", "sq", "<cmd>close<CR>", { desc = "Close current split" })

-- Navigate window
map({ "n", "v", "o" }, "sh", "<C-w>h", { desc = "Go to left window", remap = true })
map({ "n", "v", "o" }, "sj", "<C-w>j", { desc = "Go to lower window", remap = true })
map({ "n", "v", "o" }, "sk", "<C-w>k", { desc = "Go to upper window", remap = true })
map({ "n", "v", "o" }, "sl", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window
map("n", "s<left>", ":vertical resize +20<cr>")
map("n", "s<right>", ":vertical resize -20<cr>")
map("n", "s<up>", ":resize +10<cr>")
map("n", "s<down>", ":resize -10<cr>")

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")
map("n", "<", "v<g")
map("n", ">", "v>g")

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")
map("i", " ", " <c-g>u")

-- Number
map("v", "+", "g<C-a>")
map("v", "-", "g<C-x>")
map("n", "<leader>+", "<C-a>")
map("n", "<leader>-", "<C-x>")

-- File
map("n", "<C-n>", "<cmd>enew<cr>", { desc = "New File" })
map("n", "<leader>fq", "<cmd>q!<CR>")
map("n", "<leader>fw", "<cmd>wa<CR>")
map("n", "<leader>fa", "<cmd>wqa<CR>")

-- Surround
map("n", "vw", "viw")
map("n", "vp", "vip")
map("n", "vb", "vib")

-- Yank
-- map("n", "yp", "yyp")
-- map("n", "yw", "yaw")

-- Disable Mark
map({ "n", "x" }, "m", "<Nop>")

------------- Plugins -------------

-- Lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy Menu" })
map("n", "<leader>ra", "<cmd>LazyExtras<cr>", { desc = "LazyVim Extras" })
map("n", "<leader>`", function()
  require("lazy").profile()
end, { desc = "Lazy Profile" })

-- NerdIcons
map("n", "<leader>ni", ":NerdIcons<CR>", opts)
