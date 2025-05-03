return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern", -- classic | modern | helix
    notify = true,
    plugins = { marks = false, spelling = true, registers = true },
    spec = {
      {
        { "<leader>r", group = "misc", icon = { icon = "󱖫 ", color = "green", mode = { "n", "x", "s", "v" } } },
      },
    },
  },
  opts_extend = { "spec" },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Keymaps (which-key)",
    },
  },
}
