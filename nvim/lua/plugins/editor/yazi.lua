return {
  "mikavilpas/yazi.nvim",
  version = "*",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  opts = {
    open_for_directories = false,
    yazi_floating_window_border = "rounded",
  },
  keys = {
    {
      ";y",
      "<cmd>Yazi<cr>",
      mode = { "n", "x" },
      desc = "Terminal File Manager",
    },
  },
}
