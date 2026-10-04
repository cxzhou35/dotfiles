return {
  {
    "nvim-treesitter/nvim-treesitter",
    ---@type lazyvim.TSConfig
    opts = {
      install_dir = vim.fn.stdpath("data") .. "/treesitter",
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
    opts = { mode = "cursor", max_lines = 3 },
  },
}
