return {
  { "gcmt/wildfire.vim" },
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
  { "tpope/vim-repeat", lazy = true },
  { "max397574/better-escape.nvim", event = "InsertEnter", opts = { timeout = 100 } },
  {
    "sontungexpt/url-open",
    branch = "mini",
    cmd = "URLOpenUnderCursor",
    keys = {
      { "gx", "<esc>:URLOpenUnderCursor<cr>", desc = "Open URL under cursor" },
    },
    config = function()
      local status_ok, url_open = pcall(require, "url-open")
      if not status_ok then
        return
      end
      url_open.setup({})
    end,
  },
}
