return {
  {
    "nvim-mini/mini.surround",
    enabled = true,
    opts = {
      mappings = {
        add = "ma",
        delete = "md",
        find = "mf",
        find_left = "mF",
        highlight = "mh",
        replace = "mr",
        update_n_lines = "mn", -- Update `n_lines`

        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },

      silent = true,
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        {
          { "m", group = "surround", icon = { icon = "󱖫 ", color = "blue", mode = { "n", "x", "s", "v" } } },
        },
      },
    },
  },
}
