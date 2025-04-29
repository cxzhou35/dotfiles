local explorer = "neotree" -- snacks | neotree

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = explorer == "neotree",
    opts = {
      source_selector = {
        winbar = false,
        statusline = false,
      },
      buffers = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        group_empty_dirs = true,
        show_unloaded = true,
      },
      filesystem = {
        hide_gitignored = false,
        hide_by_name = {
          "node_modules",
          "__pycache__",
          ".git",
          ".next",
        },
        never_show = {
          ".DS_Store",
          "thumbs.db",
        },
      },
      window = {
        position = "left",
        width = 30,
        mappings = {
          ["<cr>"] = "open",
          ["t"] = "open_tabnew",
          ["a"] = {
            "add",
            config = {
              show_path = "relative", -- "none", "relative", "absolute"
            },
          },
          ["s"] = "noop",
          ["d"] = "delete",
          ["r"] = "rename",
          ["h"] = "toggle_hidden",
          ["<C-l>"] = "clear_filter",
          ["/"] = "fuzzy_finder",
          ["?"] = "show_help",
          ["o"] = "open_vsplit",
          ["n"] = "add_directory",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy Path to Clipboard",
          },
          ["O"] = {
            function(state)
              require("lazy.util").open(state.tree:get_node().path, { system = true })
            end,
            desc = "Open with System Application",
          },
        },
      },
      popup_border_style = "rounded",
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      enable_modified_markers = true,
      sort_case_insensitive = false,
      default_component_configs = {
        modified = {
          symbol = " ",
          highlight = "NeoTreeModified",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
          folder_empty_open = "",
          default = "*",
          highlight = "NeoTreeFileIcon",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = "NeoTreeFileName",
        },
        git_status = {
          symbols = {
            -- Change type
            added = "✚",
            modified = "",
            deleted = "✖ ",
            renamed = "󰁕 ",
            -- Status type
            untracked = " ",
            ignored = " ",
            unstaged = "󰄗 ",
            staged = " ",
            conflict = " ",
          },
        },
        indent = {
          padding = 1,
          indent_size = 2,
        },
        event_handlers = {
          {
            event = "file_opened",
            handler = function()
              --auto close
              require("neo-tree").close_all()
            end,
          },
          {
            event = "neo_tree_window_after_open",
            handler = function(args)
              if args.position == "left" or args.position == "right" then
                vim.cmd("wincmd =")
              end
            end,
          },
          {
            event = "neo_tree_window_after_close",
            handler = function(args)
              if args.position == "left" or args.position == "right" then
                vim.cmd("wincmd =")
              end
            end,
          },
        },
      },
      -- Snacks rename
      opts = function(_, opts)
        local function on_move(data)
          Snacks.rename.on_rename_file(data.source, data.destination)
        end
        local events = require("neo-tree.events")
        opts.event_handlers = opts.event_handlers or {}
        vim.list_extend(opts.event_handlers, {
          { event = events.FILE_MOVED, handler = on_move },
          { event = events.FILE_RENAMED, handler = on_move },
        })
      end,
    },
    keys = {
      {
        "<C-e>",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      explorer = { enabled = explorer == "snacks", replace_netrw = true },
    },
    keys = {
      {
        "<C-e>",
        function(opts)
          Snacks.explorer.open(opts)
        end,
        desc = "Explorer Snacks",
      },
    },
  },
}
