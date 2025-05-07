return {
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
