local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = {
        news = {
          neovim = true,
        },
      },
    },

    -- import/override with your plugins
    { import = "plugins.colorscheme" },
    { import = "plugins.code" },
    { import = "plugins.ui" },
    { import = "plugins.editor" },
    { import = "plugins.utils" },
    { import = "plugins.lang" },
  },
  ui = {
    backdrop = 100,
  },
  defaults = {
    lazy = true,
    version = false, -- always use the latest git commit
  },
  install = { colorscheme = { "catppuccin", "habamax" } },
  -- Keep startup deterministic; check explicitly with :Lazy check when needed.
  checker = { enabled = false },
  change_detection = {
    enabled = true,
    notify = false,
  },
  diff = {
    cmd = "terminal_git",
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tutor",
        "zipPlugin",
        "matchit",
        "matchparen",
      },
    },
  },
})
