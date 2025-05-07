return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    local icons = LazyVim.config.icons
    vim.o.laststatus = vim.g.lualine_laststatus

    local function getLspName()
      local msg = "No Active Lsp"
      local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
      local clients = vim.lsp.get_clients()
      if next(clients) == nil then
        return msg
      end
      for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
          return "  " .. client.name
        end
      end
      return "  " .. msg
    end

    local function getCondaEnv()
      local env_name = require("nvim-conda").utils.get_conda_environments()
      return "🅒 " .. env_name
    end

    local colors = {
      [""] = Snacks.util.color("Special"),
      ["Normal"] = Snacks.util.color("Special"),
      ["Warning"] = Snacks.util.color("DiagnosticError"),
      ["InProgress"] = Snacks.util.color("DiagnosticWarn"),
    }

    local opts = {
      options = {
        theme = "auto",
        globalstatus = vim.o.laststatus == 3,
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
              TelescopePrompt = "Telescope",
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
          -- { getCondaEnv },
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
          Snacks.profiler.status(),
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
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function()
              return { fg = Snacks.util.color("Special") }
            end,
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
