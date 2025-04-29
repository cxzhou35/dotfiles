return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    styles = {
      notification = { border = "rounded" },
      notification_history = { border = "rounded", width = 0.9, height = 0.9, minimal = true },
      snacks_image = {
        border = "rounded",
      },
    },
    notifier = {
      enabled = true,
      border = "rounded",
      timeout = 2000,
    },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    input = { enabled = true },

    -- disabled modules
    words = { enabled = false, debounce = 10, notify_end = false },
  },
  keys = {
    {
      ";ll",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      ";lg",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "Lazygit",
    },
    {
      ";la",
      function()
        Snacks.lazygit.log()
      end,
      desc = "Lazygit",
    },
    {
      ";n",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
    {
      "<leader>go",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse",
    },
    {
      "]]",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Next Reference",
      mode = { "n", "t" },
    },
    {
      "[[",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Prev Reference",
      mode = { "n", "t" },
    },
  },
}
