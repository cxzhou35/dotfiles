return {
  "saghen/blink.cmp",
  dependencies = {
    { "rafamadriz/friendly-snippets" },
  },
  version = "1.*",
  event = "InsertEnter",
  opts = {
    keymap = {
      preset = "enter",
      ["<C-y>"] = { "show", "show_documentation", "hide_documentation" },
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "snippet_forward", "fallback" },
      ["<C-p>"] = { "snippet_backward", "fallback" },
      ["<CR>"] = {
        function(cmp)
          if vim.fn.getcmdtype() == "" then
            return cmp.select_and_accept()
          end
        end,
        "fallback",
      },
    },
    completion = {
      list = {
        cycle = { from_top = true },
      },
      menu = {
        enabled = true,
        border = "rounded",
        winblend = vim.o.pumblend,
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind" },
            -- { "source_name" },
          },
          treesitter = { "lsp" },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 100,
        window = {
          border = "rounded",
        },
      },
      ghost_text = { enabled = true, show_with_menu = false },
    },
    signature = {
      enabled = true,
      window = { border = "single" },
    },
    cmdline = {
      -- disable cmdline for speed and performance
      enabled = false,
      completion = {
        menu = {
          auto_show = true,
        },
      },
    },
    fuzzy = {
      sorts = {
        "exact",
        -- defaults
        "score",
        "sort_text",
      },
    },
    sources = {
      -- with blink.compat
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        -- lsp = { async = true, score_offset = 0 },
        snippets = {
          score_offset = 0,
          opts = {
            friendly_snippets = true,
            search_paths = { vim.fn.stdpath("config") .. "/snippets" },
            global_snippets = { "all" },
            extended_filetypes = {},
            ignored_filetypes = {},
            should_show_items = function(ctx)
              return ctx.trigger.initial_kind ~= "trigger_character"
            end,
          },
        },
        path = {
          opts = {
            get_cwd = function(_)
              return vim.fn.getcwd()
            end,
          },
        },
        buffer = {
          opts = {
            -- or (recommended) filter to only "normal" buffers
            get_bufnrs = function()
              return vim.tbl_filter(function(bufnr)
                return vim.bo[bufnr].buftype == ""
              end, vim.api.nvim_list_bufs())
            end,
          },
        },
      },
    },
  },
}
