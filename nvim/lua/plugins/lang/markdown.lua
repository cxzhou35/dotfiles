return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline" })
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "marksman" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = { filetypes = { "markdown" }, settings = { markdown = {} } },
      },
    },
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    lazy = true,
    -- event = "VeryLazy",
    ft = { "markdown" },
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "npm install",
    keys = {
      {
        "<F5>",
        "<cmd>MarkdownPreviewToggle<cr>",
        ft = "markdown",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.g.mkdp_browser = vim.g.browser
      vim.g.mkdp_auto_close = 1
      vim.cmd([[do FileType]])
    end,
  },
  {
    {
      "dfendr/clipboard-image.nvim",
      lazy = true,
      -- event = "VeryLazy",
      opts = {
        -- You can create configuration for ceartain filetype by creating another field (markdown, in this case)
        -- If you're uncertain what to name your field to, you can run `lua print(vim.bo.filetype)`
        -- Missing options from `markdown` field will be replaced by options from `default` field
        markdown = {
          img_dir = { "assets", "img" },
          img_dir_txt = "assets/img",
          img_handler = function(img)
            vim.cmd("normal! f[") -- go to [
            vim.cmd("normal! a" .. img.name) -- append text with image name
          end,
        },
        tex = {
          affix = "\\begin{figure}[htbp]\n\\centering\n\\includegraphics[width=0.5\\textwidth]{%s}\n\\caption{}\n\\label{fig:}\n\\end{figure}",
        },
      },
      ft = { "tex", "markdown" },
      keys = {
        { "<leader>ri", "<cmd>PasteImg<cr>", desc = "Paste image" },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    keys = {
      { "<leader>rm", "<cmd>RenderMarkdown toggle<cr>", ft = "markdown", desc = "Render markdown" },
    },
    opts = {
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = {},
      },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ft = { "markdown", "norg", "rmd", "org" },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      Snacks.toggle({
        name = "Render Markdown",
        get = function()
          return require("render-markdown.state").enabled
        end,
        set = function(enabled)
          local m = require("render-markdown")
          if enabled then
            m.enable()
          else
            m.disable()
          end
        end,
      }):map("<leader>um")
    end,
  },
}
