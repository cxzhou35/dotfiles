return {
  "folke/noice.nvim",
  keys = { { "<c-f>", false }, { "<c-b>", false } },
  event = "VeryLazy",
  opts = {
    lsp = {
      -- LSP progress is already shown by the throttled Snacks notification
      -- in config/autocmds.lua. Disable Noice's duplicate bottom-right view.
      progress = {
        enabled = false,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = true,
      lsp_doc_border = true,
    },
  },
  config = function(_, opts)
    if vim.o.filetype == "lazy" then
      vim.cmd([[messages clear]])
    end
    require("noice").setup(opts)
  end,
}
