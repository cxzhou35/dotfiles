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
    "mason-org/mason.nvim",
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
      ft = { "tex", "markdown" },
      opts = {
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
      keys = {
        { "<leader>ri", "<cmd>PasteImg<cr>", desc = "Paste image" },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "norg", "rmd", "org" },
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
    dependencies = { "nvim-treesitter/nvim-treesitter" },
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
    keys = {
      { "<leader>rm", "<cmd>RenderMarkdown toggle<cr>", ft = "markdown", desc = "Render markdown" },
    },
  },
}
