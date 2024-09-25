return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  opts = function()
    local opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        css = { "prettier", stop_after_first = true },
        html = { "prettier", stop_after_first = true },
        json = { "prettier", stop_after_first = true },
        yaml = { "prettier", stop_after_first = true },
        python = { "isort", "autopep8" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        markdown = { "prettier", stop_after_first = true },
        tex = { "latexindent" },
        sh = { "shfmt" },
      },
      formatters = {
        lsp_format = "fallback",
        injected = { options = { ignore_errors = true } },
      },
    }
    return opts
  end,
}
