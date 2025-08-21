return {
  "folke/snacks.nvim",
  opts = {
    terminal = {
      enabled = true,
      win = {
        position = "float",
        border = "rounded",
        title = "Terminal",
        title_pos = "left",
      },
    },
  },
  keys = {
    {
      ";t",
      function()
        Snacks.terminal()
      end,
      desc = "Toggle Terminal",
    },
  },
}
