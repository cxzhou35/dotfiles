return {
  {
    "NeogitOrg/neogit",
    lazy = true,
    keys = { { "<leader>gn", "<cmd>Neogit<cr>", desc = "Open Neogit" } },
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "nvim-telescope/telescope.nvim",
    },
    config = true,
  },
  {
    "folke/snacks.nvim",
    opts = {
      git = {
        win = {
          styles = {
            width = 0.6,
            height = 0.6,
            border = "rounded",
            title = " Git Blame ",
            title_pos = "center",
            ft = "git",
          },
        },
      },
      gitbrowse = {
        notify = false,
      },
    },
    keys = {
      {
        "<leader>go",
        function(opts)
          Snacks.gitbrowse.open(opts)
        end,
        desc = "Git Browse",
      },
      {
        "<leader>gb",
        function()
          Snacks.git.blame_line()
        end,
        desc = "Git Blame Line",
      },
      {
        "<leader>gs",
        function()
          Snacks.picker.git_status()
        end,
        desc = "Git Status",
      },
      {
        "<leader>gd",
        function()
          Snacks.picker.git_diff()
        end,
        desc = "Git Diff(Hunks)",
      },
      {
        ";l",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
      {
        "<leader>gl",
        function()
          Snacks.lazygit.log_file()
        end,
        desc = "Lazygit Log",
      },
    },
  },
}
