local zen = "snacks"

return {
  {
    -- NOTE: use Snacks.zen now
    "folke/zen-mode.nvim",
    enabled = zen == "zen-mode",
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
    cmd = "ZenMode",
    opts = {
      window = {
        backdrop = 0.95,
        options = {
          colorcolumn = "",
          signcolumn = "no",
          number = true,
          relativenumber = true,
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = "0",
          list = false,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0,
        },
        twilight = { enabled = false },
        tmux = { enabled = true },
        gitsigns = { enabled = false },
        kitty = { enabled = false, font = "+20%" },
      },
      on_open = function()
        require("incline").disable()
      end,
      on_close = function()
        require("incline").enable()
      end,
    },
  },
  {
    "floke/snacks.nvim",
    opts = {
      zen = {
        enabled = zen == "snacks",
        toggles = {
          dim = false,
          git_signs = false,
          mini_diff_signs = false,
          diagnostics = false,
          inlay_hints = false,
        },
        show = {
          statusline = false,
          tabline = false,
        },
        win = {
          styles = "zen",
          width = 120,
          minimal = true,
          wo = {
            number = true,
            relativenumber = true,
          },
        },
        on_open = function()
          require("incline").disable()
        end,
        on_close = function()
          require("incline").enable()
        end,
        zoom = {
          toggles = {},
          show = { statusline = true, tabline = true },
          win = {
            backdrop = false,
            width = 0, -- full width
          },
        },
      },
    },
    keys = {
      {
        ";z",
        function()
          Snacks.zen()
        end,
        desc = "Toggle Zen Mode",
      },
      {
        ";m",
        function()
          Snacks.zen.zoom()
        end,
        desc = "Toggle Zoom",
      },
    },
  },
}
