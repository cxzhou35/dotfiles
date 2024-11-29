return {
  -- Incremental rename
  "smjonas/inc-rename.nvim",
  cmd = "IncRename",
  config = true,
  keys = { { "<leader>rn", "<cmd>IncRename<cr>", desc = "IncRename" } },
  opts = { show_message = true, save_in_cmdline_history = true },
}
