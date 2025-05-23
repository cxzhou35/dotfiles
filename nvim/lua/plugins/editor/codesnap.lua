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
  {
    "ellisonleao/carbon-now.nvim",
    lazy = true,
    cmd = "CarbonNow",
    opts = {
      options = {
        theme = "material",
        window_theme = "none",
        background_mode = "color",
        bg = "gray",
        background_color = "rgba(240, 231, 231, 1.0)",
        font_family = "Hack",
        font_size = "16px",
        line_numbers = true,
        line_height = "133%",
        drop_shadow = true,
        drop_shadow_offset_y = "26px",
        drop_shadow_blur = "68px",
        drop_shadow_blur_radius = "49px",
        padding_vertical = "44px",
        padding_horizontal = "37px",
        width = "680",
        width_adjustment = "true",
        first_line_number = "1",
        watermark = false,
      },
    },
    keys = {
      {
        "<leader>cn",
        "<cmd>CarbonNow<cr>",
        mode = { "v", "n", "x" },
        desc = "Generate a code snippet from the current buffer",
      },
    },
  },
}
