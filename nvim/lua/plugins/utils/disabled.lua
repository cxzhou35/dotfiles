local disabled = {
  { "rmagatti/auto-session" },
  { "mg979/vim-visual-multi" },
  { "junegunn/vim-easy-align" },
  { "windwp/nvim-ts-autotag" },
  { "abecodes/tabout.nvim" },
  { "phaazon/hop.nvim" },
  { "m4xshen/hardtime.nvim" },
  -- { "axieax/urlview.nvim" },
  { "folke/persistence.nvim" },
  -- cmp
  { "hrsh7th/cmp-cmdline" },
  -- git
  -- { "NeogitOrg/neogit" },
  {
    "sindrets/diffview.nvim",
  },
  -- copilot
  -- { "zbirenbaum/copilot.lua" },
  -- { "CopilotC-Nvim/CopilotChat.nvim" },
  -- lsp
  { "mfussenegger/nvim-lint" },
  -- notify
  -- { "folke/noice.nvim" },
  { "rcarriga/nvim-notify" },
  -- treesitter
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  -- terminal
  { "akinsho/toggleterm.nvim" },
  -- ui
  { "mawkler/modicator.nvim" },
  { "gen740/SmoothCursor.nvim" },
  -- suround
  -- { "echasnovski/mini.surround" }, -- INFO: use mini.suround
  -- { "kylechui/nvim-surround" },
  -- startpage
  { "goolord/alpha-nvim" },
  { "nvimdev/dashboard-nvim" },
  -- indentline
  { "lukas-reineke/indent-blankline.nvim" }, -- INFO: use hlchunk
  { "echasnovski/mini.indentscope" },
  -- { "shellRaining/hlchunk.nvim"},
  -- snippets
  -- { "L3MON4D3/LuaSnip"}, -- INFO: use Luasnip
  { "garymjr/nvim-snippets" },
  -- conda env
  { "linux-cultist/venv-selector.nvim" }, -- INFO: use nvim-conda
  -- { "kmontocam/nvim-conda"}
  -- dev
}

for i, plugin in ipairs(disabled) do
  plugin.enabled = false
end

return disabled
