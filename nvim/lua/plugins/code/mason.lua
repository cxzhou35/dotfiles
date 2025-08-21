return {
  {
    "williamboman/mason.nvim",
    version = "^1.0.0",
    keys = { { "<leader>m", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "luacheck",
        "basedpyright",

        "shfmt",
      },
    },
  },
  { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
}
