return {
  {
    "mason-org/mason.nvim",
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
  { "mason-org/mason-lspconfig.nvim" },
}
