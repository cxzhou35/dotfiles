return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  opts = function()
    local opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        toml = { "taplo" },
        tex = { "latexindent" },
        sh = { "shfmt" },
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
}
