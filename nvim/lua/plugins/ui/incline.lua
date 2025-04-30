return {
  {
    "b0o/incline.nvim",
    dependencies = {},
    event = "BufReadPre",
    priority = 1200,
    keys = {
      { "<leader>I", "<CMD>lua require('incline').toggle()<CR>", desc = "Toggle Incline" },
    },
    config = function()
      local colors = require("catppuccin.palettes.macchiato")
      require("incline").setup({
        highlight = {
          groups = {
            InclineNormal = { guifg = colors.pink, guibg = colors.base },
            InclineNormalNC = { guifg = colors.lavender, guibg = colors.base },
          },
        },
        window = {
          padding = 0,
          margin = { vertical = 0, horizontal = 1 },
          placement = {
            vertical = "top",
            horizontal = "right",
          },
        },
        hide = {
          cursorline = true,
        },
        ignore = {
          buftypes = {},
          filetypes = { "neo-tree" },
          unlisted_buffers = false,
        },
        render = function(props)
          local function get_filename()
            local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
            if filename == "" then
              filename = "[No Name]"
            end
            if vim.bo[props.buf].modified then
              filename = "[+] " .. filename
            end
            local icon, color = require("nvim-web-devicons").get_icon_color(filename)
            return {
              { icon, guifg = color },
              { " " },
              { filename },
            }
          end

          local function get_window_number()
            return {
              " ┊  " .. vim.api.nvim_win_get_number(props.win),
              group = "DevIconWindows",
              guifg = colors.teal,
            }
          end

          return {
            { get_filename() },
            { get_window_number() },
            group = props.focused and "ColorColumn" or "SignColumn",
          }
        end,
      })
    end,
  },
}
