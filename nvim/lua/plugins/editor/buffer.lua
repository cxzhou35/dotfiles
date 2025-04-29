return {
  {
    "glepnir/flybuf.nvim",
    cmd = "FlyBuf",
    opts = {
      hotkey = "asdfghwertyuiopzcvbnm", -- hotkye
      border = "single", -- border
      quit = "q", -- quit flybuf window
      mark = "m", -- mark as delet or cancel delete
      delete = "x", -- delete marked buffers or buffers which cursor in
    },
    keys = {
      { "<leader>bf", "<cmd>FlyBuf<cr>", mode = "n", desc = "Open FlyBuf" },
    },
  },
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<C-q>",
        function()
          Snacks.bufdelete()
          -- Snacks.bufdelete.delete()
        end,
        desc = "Delete buffer",
      },
      {
        "<C-c>",
        function(opts)
          Snacks.bufdelete.all(opts)
        end,
      },
    },
  },
}
