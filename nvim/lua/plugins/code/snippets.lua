return {
  -- NOTE: use blink.cmp now
  {
    "garymjr/nvim-snippets",
    enabled = false,
    opts = {
      friendly_snippets = true,
      search_paths = { "~/.config/nvim/snippets/friendly-snippets/" },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    enabled = false,
    build = (not LazyVim.is_win())
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load({
            paths = { "~/.config/nvim/snippets/friendly-snippets/" },
          })
        end,
      },
    },
    keys = {},
  },
}
