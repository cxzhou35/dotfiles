return {
  "rolv-apneseth/tfm.nvim",
  event = "VeryLazy",
  opts = {
    file_manager = "yazi",
    enable_cmds = false,
    replace_netrw = true,
    ui = {
      border = "rounded",
    },
  },
  keys = {
    {
      ";y",
      function()
        require("tfm").open()
      end,
      desc = "Terminal File Manager",
    },
  },
}
