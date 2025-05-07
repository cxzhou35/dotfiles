return {
  "wakatime/vim-wakatime",
  evert = "BufReadPost",
  keys = {
    { "<leader>rw", "<cmd>WakaTimeToday<cr>", desc = "Show Wakatime Today" },
    { "<leader>rk", "<cmd>WakaTimeApiKey<cr>", desc = "Edit Wakatime Api Key" },
  },
}
