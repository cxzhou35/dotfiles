local disabled = {
  { "folke/persistence.nvim" },
  { "ibhagwan/fzf-lua" },
  { "mfussenegger/nvim-lint" },
  { "hrsh7th/nvim-cmp" },
  { "rcarriga/nvim-notify" },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
}

for idx, plugin in ipairs(disabled) do
  plugin.enabled = false
end

return disabled
