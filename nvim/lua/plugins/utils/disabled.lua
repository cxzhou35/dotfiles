local disabled = {
  { "rmagatti/auto-session" },
  { "mg979/vim-visual-multi" },
  -- { "windwp/nvim-ts-autotag" },
  { "abecodes/tabout.nvim" },
  { "phaazon/hop.nvim" },
  { "m4xshen/hardtime.nvim" },
  -- { "axieax/urlview.nvim" },
  { "folke/persistence.nvim" },
  -- git
  -- { "NeogitOrg/neogit" },
  {
    "sindrets/diffview.nvim",
  },
  -- copilot
  -- { "zbirenbaum/copilot.lua" },
  -- { "CopilotC-Nvim/CopilotChat.nvim" },
  -- fzf picker
  { "ibhagwan/fzf-lua" },
  -- lsp
  { "mfussenegger/nvim-lint" },
  -- completion
  { "hrsh7th/nvim-cmp" },
  -- { "saghen/blink.cmp" },
  -- notify
  -- { "folke/noice.nvim" },
  { "rcarriga/nvim-notify" },
  -- treesitter
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  -- terminal
  { "akinsho/toggleterm.nvim" },
  -- ui
  -- { "mawkler/modicator.nvim" },
  { "gen740/SmoothCursor.nvim" },
  -- suround
  -- { "echasnovski/mini.surround" }, -- INFO: use mini.suround
  -- { "kylechui/nvim-surround" },
  -- conda env
  { "linux-cultist/venv-selector.nvim" }, -- INFO: use nvim-conda
  -- { "kmontocam/nvim-conda"}
  -- dev
}

for i, plugin in ipairs(disabled) do
  plugin.enabled = false
end

return disabled
