local disabled = {
  { "m4xshen/hardtime.nvim" },
  -- { "gen740/SmoothCursor.nvim" },
  { "sphamba/smear-cursor.nvim" },
  -- { "axieax/urlview.nvim" },
  { "folke/persistence.nvim" },
  { "NeogitOrg/neogit" },
  { "ibhagwan/fzf-lua" },
  { "mfussenegger/nvim-lint" },
  { "hrsh7th/nvim-cmp" },
  { "rcarriga/nvim-notify" },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "mawkler/modicator.nvim" },
  -- { "nvim-zh/colorful-winsep.nvim" },
  -- { "echasnovski/mini.surround" },
  -- { "kylechui/nvim-surround" },
  -- { "kmontocam/nvim-conda"}
}

for idx, plugin in ipairs(disabled) do
  plugin.enabled = false
end

return disabled
