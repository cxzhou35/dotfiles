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
        window = {
          border = "rounded",
        },
      },
      ghost_text = {
        enabled = vim.g.ai_cmp,
      },
      -- Experimental signature help support
      -- signature = { enabled = true },
    },
    signature = {
      window = {
        winblend = vim.o.pumblend,
      },
    },
    sources = {
      -- adding any nvim-cmp sources here will enable them
      -- with blink.compat
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        lsp = { async = true, score_offset = 0 },
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
        copilot = { score_offset = 10 },
      },
    },
  },
}
