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
    -- Use the plugin's prebuilt binary installer instead of a root npm install,
    -- so Lazy updates do not leave package-lock/yarn changes in the checkout.
    build = function(plugin)
      vim.opt.runtimepath:append(plugin.dir)
      vim.fn["mkdp#util#install_sync"](1)
    end,
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
      vim.cmd("doautocmd mkdp_init FileType")
    end,
  },
  {
    "HakonHarnes/img-clip.nvim",
    cmd = { "PasteImage", "ImgClipDebug", "ImgClipConfig" },
    opts = {
      default = {
        dir_path = "assets/img",
      },
      filetypes = {
        markdown = {
          url_encode_path = true,
          template = "![$CURSOR]($FILE_PATH)",
          download_images = false,
        },
        tex = {
          relative_template_path = false,
          template = table.concat({
            "\\begin{figure}[htbp]",
            "\\centering",
            "\\includegraphics[width=0.5\\textwidth]{$FILE_PATH}",
            "\\caption{$CURSOR}",
            "\\label{fig:$LABEL}",
            "\\end{figure}",
          }, "\n"),
          formats = { "jpeg", "jpg", "png", "pdf" },
        },
      },
    },
    keys = {
      { "<leader>ri", "<cmd>PasteImage<cr>", ft = { "markdown", "tex" }, desc = "Paste image" },
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
