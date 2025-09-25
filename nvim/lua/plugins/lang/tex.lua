return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "bibtex", "latex" })
      end
      if type(opts.highlight.disable) == "table" then
        vim.list_extend(opts.highlight.disable, { "latex" })
      else
        opts.highlight.disable = { "latex" }
      end
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "texlab", "tex-fmt" })
    end,
  },

  {
    "lervag/vimtex",
    lazy = false, -- lazy-loading will disable inverse search
    ft = { "tex", "bib" },
    keys = { { "<leader>v", ":VimtexView<CR>", desc = "Vimtex Preview" } },
    init = function()
      -- maapings
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
      -- viewer
      vim.g.vimtex_view_enabled = 1
      vim.g.vimtex_view_automatic = 1
      vim.g.vimtex_view_method = "sioyek"
      -- quickfix
      vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
      vim.g.vimtex_quickfix_open_on_warning = 0
      vim.g.vimtex_quickfix_ignore_filters = {
        "Underfull",
        "Overfull",
        "Underfull \\hbox",
        "Overfull \\hbox",
        "specifier changed to",
        "Token not allowed in a PDF string",
        "LaTeX Warning: Float too large for page",
        "contains only floats",
        "LaTeX hooks Warning",
        "LaTeX Warning: .+ float specifier changed to",
        'Package siunitx Warning: Detected the "physics" package:',
        "Package hyperref Warning: Token not allowed in a PDF string",
        "Fatal error occurred, no output PDF file produced!",
      }
      -- compiler
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_silent = 1
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          local buf_ft = vim.bo.filetype
          if buf_ft == "tex" then
            vim.cmd("VimtexCompile")
          end
        end,
      })
    end,
    config = function() end,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        texlab = {
          filetypes = { "tex", "bib" },
          keys = {
            { "<Leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true },
          },
        },
      },
    },
  },
}
