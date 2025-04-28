local indent = "snacks" -- ibl | hlc | mini | snacks
return {
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = indent == "ibl",
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
    enabled = indent == "hlc",
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
    enabled = indent == "mini",
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
  {
    "folke/snacks.nvim",
    opts = {
      indent = {
        enabled = indent == "snacks",
        indent = {
          char = "┆",
          only_scope = false,
          only_current = true,
          hl = "SnacksIndent",
        },
        animate = {
          duration = {
            step = 10,
            duration = 100,
          },
        },
        scope = {
          enabled = true,
          priority = 200,
          char = "┊",
          underline = false,
          only_current = true,
          hl = {
            "SnacksIndent1",
            "SnacksIndent2",
            "SnacksIndent3",
            "SnacksIndent4",
            "SnacksIndent5",
            "SnacksIndent6",
            "SnacksIndent7",
            "SnacksIndent8",
          },
        },
        chunk = {
          enabled = false,
          priority = 200,
          only_current = true,
          hl = "SnacksIndentChunk",
        },
      },
    },
  },
}
