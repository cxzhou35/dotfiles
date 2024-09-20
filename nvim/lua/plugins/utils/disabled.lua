local disabled = {
  { "rmagatti/auto-session" },
  { "mg979/vim-visual-multi" },
  { "junegunn/vim-easy-align" },
  { "windwp/nvim-ts-autotag" },
  { "phaazon/hop.nvim" },
  -- { "m4xshen/hardtime.nvim"},
  { "axieax/urlview.nvim" },
  { "folke/persistence.nvim" },
  -- cmp
  { "hrsh7th/cmp-cmdline" },
  -- git
  { "NeogitOrg/neogit" },
  -- lsp
  { "mfussenegger/nvim-lint" },
  -- treesitter
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  -- ui
  { "mawkler/modicator.nvim" },
  { "gen740/SmoothCursor.nvim" },
  -- suround
  { "echasnovski/mini.surround" }, -- INFO: use mini.suround
  -- { "kylechui/nvim-surround"},
  -- startpage
  { "goolord/alpha-nvim" }, -- INFO: use dashboard
  -- { "nvimdev/dashboard-nvim"},
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
}

for i, plugin in ipairs(disabled) do
  plugin.enabled = false
end

return disabled
