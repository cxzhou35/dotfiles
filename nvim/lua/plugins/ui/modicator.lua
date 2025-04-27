return {
  "mawkler/modicator.nvim",
  init = function()
    -- These are required for Modicator to work
    vim.o.cursorline = true
    vim.o.number = true
    vim.o.termguicolors = true
  end,
  opts = {
    show_warnings = false,
    highlights = {
      defaults = {
        bold = true,
        italic = true,
      },
      use_cursorline_background = false,
    },
    integration = {
      lualine = {
        enabled = false,
        mode_section = nil,
        highlight = "bg",
      },
    },
  },
}
