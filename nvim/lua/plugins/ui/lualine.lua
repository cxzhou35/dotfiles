return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    local lualine_require = require("lualine_require")
    lualine_require.require = require

    local icons = LazyVim.config.icons
    local laststatus = vim.g.lualine_laststatus or vim.o.laststatus
    if vim.bo.filetype ~= "snacks_dashboard" then
      vim.o.laststatus = laststatus
    end

    local function getLspName()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      return #clients > 0 and "  " .. clients[1].name or "No Active Lsp"
    end

    local opts = {
      options = {
        theme = "auto",
        globalstatus = laststatus == 3,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
        -- increase the default update time
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "filetype",
            icon_only = true,
            separator = "",
            padding = { left = 1, right = 0 },
            filetype_names = {
              lazy = "Lazy",
              packer = "Packer",
            },
          },
          {
            "filename",
            path = 0, -- 0: Just the filename
            -- 1: Relative path
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory
            symbols = {
              added = "󱪞",
              removed = "󱪜",
              modified = "󰷉",
              readonly = "󱪠",
              unnamed = "󱪘",
              directory = "",
            },
          },
          { getLspName },
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
              bug = icons.diagnostics.Bug,
            },
          },
        },
        lualine_x = {
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = function() return { fg = Snacks.util.color("Statement") } end,
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = function() return { fg = Snacks.util.color("Constant") } end,
          },
          {
            "copilot",
            -- Default values
            symbols = {
              status = {
                icons = {
                  enabled = " ",
                  sleep = " ", -- auto-trigger disabled
                  disabled = " ",
                  warning = " ",
                  unknown = " ",
                },
                hl = {
                  enabled = "#9EDFA6",
                  sleep = "#9EDFA6",
                  -- sleep = "#AEB7D0",
                  disabled = "#6272A4",
                  warning = "#DA9F7E",
                  unknown = "#bb1c33",
                },
              },
            },
            show_colors = true,
            show_loading = true,
          },
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          {
            function()
              return " " .. os.date("%R")
            end,
          },
        },
      },
      extensions = { "neo-tree", "lazy" },
    }
    return opts
  end,
}
