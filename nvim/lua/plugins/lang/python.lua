local lsp = "basedpyright"

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "ninja", "python", "rst", "toml" })
      end
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "basedpyright", "black", "mypy" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          enabled = lsp == "basedpyright",
          filetypes = { "python" },
          root_makers = {
            "pyproject.toml",
            "setup.py",
            "setup.cfg",
            "requirements.txt",
            "Pipfile",
            "pyrightconfig.json",
            ".git",
          },
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic", -- "off" | "basic" | "standard" | "strict" | "recommended" | "all"
                autoSearchPaths = true,
                autoImportCompletions = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                diagnosticSeverityOverrides = {
                  reportAny = false,
                  reportMissingTypeArgument = false,
                  reportMissingTypeStubs = false,
                  reportUnknownMemberType = false,
                  reportUnknownVariableType = false,
                  reportUnusedCallResult = false,
                  reportUnusedImport = false,
                  reportUnknownArgumentType = false,
                  reportUnknownParameterType = false,
                  reportMissingImports = "error",
                  reportMissingParameterType = false,
                },
              },
            },
          },
        },
        pyright = {
          enabled = lsp == "pyright",
          filetypes = { "python" },
          settings = {
            python = {
              analysis = {
                logLevel = "Warning",
                typeCheckingMode = "basic", -- off, basic, strict
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                autoImportCompletions = true,
                diagnosticMode = "workspace",
                diagnosticSeverityOverrides = {
                  strictListInference = true,
                  strictDictionaryInference = true,
                  strictSetInference = true,
                  reportUnusedImport = "warning",
                  reportUnusedClass = "warning",
                  reportUnusedFunction = "warning",
                  reportUnusedVariable = "warning",
                  reportUnusedCoroutine = "warning",
                  reportDuplicateImport = "warning",
                  reportPrivateUsage = "warning",
                  reportUnusedExpression = "warning",
                  reportConstantRedefinition = "error",
                  reportIncompatibleMethodOverride = "error",
                  reportMissingImports = "error",
                  reportUndefinedVariable = "error",
                  reportAssertAlwaysTrue = "error",
                },
              },
            },
          },
        },
      },
    },
  },
  {
    "kmontocam/nvim-conda",
    ft = { "python" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      -- { "<leader>ac", "<cmd>CondaActivate<cr>", desc = "Activate Conda Env" },
      -- { "<leader>ad", "<cmd>CondaDeactivate<cr>", desc = "Deactivate Conda Env" },
    },
  },
}
