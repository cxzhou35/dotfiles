return {
  -- NOTE: use Snacks.zen now
  "folke/zen-mode.nvim",
  enabled = false,
  keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  cmd = "ZenMode",
  opts = {
    window = {
      backdrop = 0.95,
      options = {
        colorcolumn = "",
        signcolumn = "no",
        number = true,
        relativenumber = true,
        cursorline = false,
        cursorcolumn = false,
        foldcolumn = "0",
        list = false,
      },
    },
    plugins = {
      options = {
        enabled = true,
        ruler = false,
        showcmd = false,
        laststatus = 0,
      },
      twilight = { enabled = false },
      tmux = { enabled = true },
      gitsigns = { enabled = false },
      kitty = { enabled = false, font = "+20%" },
    },
  },
}
