return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "LazyFile",
    opts = {
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "neogitstatus",
          "lazyterm",
          "txt",
        },
      },
    },
    main = "ibl",
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "UIEnter", "CursorMoved" },
    config = function()
      require("hlchunk").setup({
        -- experimental
        context = {
          enable = false,
          use_treesitter = false,
          chars = {
            "┃", -- Box Drawings Heavy Vertical
          },
        },
        chunk = {
          enable = true,
          notify = false,
          use_treesitter = false,
          textobject = "",
          max_file_size = 1024 * 1024,
          error_sign = true,
        },
        indent = {
          enable = true,
          use_treesitter = true,
          chars = { "│", "¦", "┆", "┊" },
          style = {
            "#806d9c",
          },
        },
        line_num = {
          enable = false,
          use_treesitter = false,
          style = "#806d9c",
        },
        blank = {
          enable = false,
          use_treesitter = false,
          chars = {
            "․",
          },
          -- style = {
          --   { bg = "#434437" },
          --   { bg = "#2f4440" },
          --   { bg = "#433054" },
          --   { bg = "#284251" },
          -- },
        },
      })
    end,
  },
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = "LazyFile",
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "alpha",
          "dashboard",
          "fzf",
          "help",
          "lazy",
          "lazyterm",
          "mason",
          "neo-tree",
          "notify",
          "toggleterm",
          "Trouble",
          "trouble",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
}
