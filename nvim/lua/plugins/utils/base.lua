return {
  {
    "rmagatti/alternate-toggler",
    keys = {
      { "<leader>i", "<cmd>ToggleAlternate<CR>", desc = "Toggle Alternate" },
    },
    opts = {
      alternates = {
        ["true"] = "false",
        ["True"] = "False",
        ["false"] = "true",
        ["False"] = "True",
        ["TRUE"] = "FALSE",
        ["yes"] = "no",
        ["Yes"] = "No",
        ["YES"] = "NO",
        ["1"] = "0",
        ["<"] = ">",
        ["("] = ")",
        ["["] = "]",
        ["{"] = "}",
        ['"'] = "'",
        ['""'] = "''",
        ["+"] = "-",
        ["=="] = "!=",
      },
    },
  },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "max397574/better-escape.nvim", event = "InsertEnter", opts = { timeout = 100 } },
}
