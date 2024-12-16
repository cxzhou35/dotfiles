return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = {
    preset = "modern", -- classic | modern | helix
    notify = true,
    plugins = { marks = false, spelling = true, registers = true },
  },
}
