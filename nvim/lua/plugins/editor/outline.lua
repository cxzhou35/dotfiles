return {
  "hedyhli/outline.nvim",
  lazy = true,
  keys = { { "<leader>o", "<cmd>Outline<CR>", desc = "Outline Symbols", mode = { "n" } } },
  opts = {
    outline_window = {
      position = "right",
      split_command = nil,
      width = 25,
      relative_width = true,
      auto_close = false,
      auto_jump = true,
      jump_highlight_duration = 300,
      center_on_jump = true,

      show_numbers = false,
      show_relative_numbers = false,
      wrap = false,
      show_cursorline = true,
      hide_cursor = false,

      focus_on_open = true,
    },
    guides = {
      enabled = true,
      markers = {
        bottom = "└",
        middle = "├",
        vertical = "│",
      },
    },
    symbol_folding = {
      autofold_depth = 1,
      auto_unfold = {
        hovered = true,
      },
    },
  },
}
