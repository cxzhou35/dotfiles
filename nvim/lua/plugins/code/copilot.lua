return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = false,
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
        python = true,
        lua = true,
        c = true,
        cpp = true,
      },
    },
  },
  -- add ai_accept action
  {
    "zbirenbaum/copilot.lua",
    opts = function()
      LazyVim.cmp.actions.ai_accept = function()
        if require("copilot.suggestion").is_visible() then
          LazyVim.create_undo()
          require("copilot.suggestion").accept()
          return true
        end
      end
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    cmd = "CopilotChat",
    keys = { { "<leader>cu", "<cmd>CopilotChatToggle<cr>", desc = "Toggle chat window" } },
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      config = function()
        require("CopilotChat.integrations.cmp").setup()
        require("CopilotChat").setup({
          debug = false,
          show_folds = true,
          highlight_selection = true,
          mappings = {
            complete = {
              insert = "",
            },
          },
        })
      end,
    },
  },
  -- lualine integrations
  {
    "AndreM222/copilot-lualine",
  },
  -- blink.cmp integrations
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "giuxtaposition/blink-cmp-copilot" },
    opts = {
      sources = {
        default = { "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            kind = "Copilot",
          },
        },
      },
    },
  },
}
