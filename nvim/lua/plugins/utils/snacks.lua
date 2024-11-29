return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    dashboard = {
      enabled = false,
    },
    notifier = {
      enabled = false,
      border = "rounded",
    },
    words = {
      notify_end = false,
    },
  },
  keys = {
    {
      ";l",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      ";t",
      function()
        Snacks.terminal()
      end,
      desc = "Toggle Terminal",
    },
    {
      "<leader>go",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse",
    },
  },
}
