return {
  "saghen/blink.cmp",
  lazy = false,
  version = "*",
  dependencies = {
    { "rafamadriz/friendly-snippets" },
  },
  event = "InsertEnter",
  opts = {
    keymap = {
      preset = "enter",
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "snippet_forward", "fallback" },
      ["<C-p>"] = { "snippet_backward", "fallback" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
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
        cycle = { from_top = false },
      },
      accept = {
        -- experimental auto-brackets support
        auto_brackets = {
          enabled = true,
        },
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
        auto_show_delay_ms = 200,
        window = {
          border = "rounded",
        },
      },
      ghost_text = {
        enabled = vim.g.ai_cmp,
      },
    },
    signature = {
      enabled = true,
      window = {
        winblend = vim.o.pumblend,
        border = "single",
      },
    },
    cmdline = {
      completion = {
        menu = {
          auto_show = true,
        },
      },
    },
    sources = {
      -- adding any nvim-cmp sources here will enable them
      -- with blink.compat
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        -- lsp = { async = true, score_offset = 0 },
        copilot = { score_offset = 100 },
        snippets = {
          score_offset = 0,
          opts = {
            friendly_snippets = true,
            search_paths = { vim.fn.stdpath("config") .. "/snippets" },
            global_snippets = { "all" },
            extended_filetypes = {},
            ignored_filetypes = {},
          },
        },
      },
    },
  },
}
