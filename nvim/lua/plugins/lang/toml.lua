return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "taplo" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        taplo = {
          filetypes = { "toml" },
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
        },
      },
    },
  },
}
