return {

  "folke/flash.nvim",
  event = "VeryLazy",
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
    exclude = {
      "notify",
      "cmp_menu",
      "noice",
      "flash_prompt",
      function(win)
        -- exclude non-focusable windows
        return not vim.api.nvim_win_get_config(win).focusable
      end,
    },
    label = {
      rainbow = {
        enabled = true,
        -- number between 1 and 9
        shade = 2,
      },
    },
  },
  keys = {
    -- INFO: * disable default keymaps * --
    { "s", mode = { "n", "x", "o" }, false },
    { "S", mode = { "n", "x", "o" }, false },
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
}
