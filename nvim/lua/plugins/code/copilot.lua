return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-l>",
          accept_word = "<M-l>",
          accept_line = "<M-S-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
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
}
