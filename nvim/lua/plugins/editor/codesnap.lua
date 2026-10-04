return {
  {
    "mistricky/codesnap.nvim",
    build = "make",
    lazy = true,
    keys = {
      { "<leader>cs", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
      { "<leader>cv", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
    },
    opts = {
      border = "rounded",
      has_breadcrumbs = true,
      show_workspace = true,
      bg_theme = "grape",
      watermark = "",
      save_path = "~/Downloads/Screenshots",
    },
  },
}
