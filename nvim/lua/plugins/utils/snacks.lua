return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    styles = {
      notification = { border = "rounded" },
      notification_history = { border = "rounded", width = 0.7, height = 0.7, minimal = true },
      snacks_image = {
        border = "rounded",
      },
    },
    notifier = {
      enabled = true,
      border = "rounded",
      timeout = 2000,
      width = { min = 40, max = 0.6 },
      height = { min = 1, max = 0.8 },
    },
    toggle = {
      enabled = true,
      map = vim.keymap.set, -- keymap.set function to use
      which_key = true, -- integrate with which-key to show enabled/disabled icons and colors
      notify = true, -- show a notification when toggling
      icon = {
        enabled = " ",
        disabled = " ",
      },
    },

    -- utils
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    input = { enabled = true },
    bigfile = { enabled = true },
    scope = { enabled = true },

    -- disabled modules
    words = { enabled = false, debounce = 10, notify_end = false },
    animate = { enabled = false },
    picker = { enabled = false },
  },
  keys = {
    {
      ";n",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
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
