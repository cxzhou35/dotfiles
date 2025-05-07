local disabled = {
  { "m4xshen/hardtime.nvim" },
  -- animate
  -- { "gen740/SmoothCursor.nvim" },
  -- { "sphamba/smear-cursor.nvim" },
  -- { "axieax/urlview.nvim" },
  { "folke/persistence.nvim" },
  -- git
  { "NeogitOrg/neogit" },
  -- copilot
  -- { "zbirenbaum/copilot.lua" },
  -- { "CopilotC-Nvim/CopilotChat.nvim" },
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
  -- { "akinsho/toggleterm.nvim" },
  -- ui
  { "mawkler/modicator.nvim" },
  -- { "nvim-zh/colorful-winsep.nvim" },
  -- suround
  -- { "echasnovski/mini.surround" }, -- INFO: use mini.suround
  -- { "kylechui/nvim-surround" },
  -- conda env
  { "linux-cultist/venv-selector.nvim" }, -- INFO: use nvim-conda
  -- { "kmontocam/nvim-conda"}
  -- dev
}

for idx, plugin in ipairs(disabled) do
  plugin.enabled = false
end

return disabled
