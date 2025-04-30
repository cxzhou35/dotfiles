return {

  "folke/flash.nvim",
  event = "VeryLazy",
  keys = {
    { "s", false, mode = { "n", "v" } },
    { "S", false, mode = { "n", "v" } },
    {
      "fa",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "fs",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
    {
      "fw",
      function()
        require("flash").jump({
          pattern = vim.fn.expand("<cword>"),
        })
      end,
      desc = "Flash with the word under the cursor",
    },
  },
  opts = {
    continue = true,
    jump = { nohlsearch = true },
    modes = {
      search = {
        enabled = false,
        jump = { history = true, register = true, nohlsearch = true },
      },
      char = { jump_labels = true, keys = { "f", "F", "t", "T" } },
      treesitter_search = {
        label = {
          rainbow = { enabled = true },
        },
      },
    },
  },
}
