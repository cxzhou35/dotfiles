return {
  "wakatime/vim-wakatime",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    status_bar_enabled = false,
  },
  init = function()
    vim.g.loaded_wakatime = 1
  end,
  config = function(_, opts)
    require("wakatime").setup(opts)
  end,
  keys = {
    { "<leader>rw", "<cmd>WakaTimeToday<cr>", desc = "Show Wakatime Today" },
    { "<leader>rk", "<cmd>WakaTimeApiKey<cr>", desc = "Edit Wakatime Api Key" },
  },
}
