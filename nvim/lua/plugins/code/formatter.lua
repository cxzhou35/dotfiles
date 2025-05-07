return {
  "stevearc/conform.nvim",
  lazy = true,
  event = "BufWritePre",
  cmd = "ConformInfo",
  dependencies = { "mason.nvim" },
  opts = function()
    local opts = {
      notify_on_error = true,
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black", "isort" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        toml = { "taplo" },
        sh = { "shfmt" },
        tex = { "tex-fmt" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        -- json = { "prettier", stop_after_first = true },
        -- markdown = { "prettier", stop_after_first = true },
        -- yaml = { "prettier", stop_after_first = true },
      },
      formatters = {
        lsp_format = "fallback",
        injected = { options = { ignore_errors = true } },
        isort = {
          prepend_args = { "--length-sort", "--lines-after-imports", "1" },
        },
      },
    }
    return opts
  end,
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format()
      end,
      desc = "Format buffer",
    },
    {
      "<leader>cF",
      function()
        require("conform").format({ lsp_format = false })
      end,
      desc = "Format buffer without LSP",
    },
  },
}
