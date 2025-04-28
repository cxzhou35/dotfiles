local M = {}

local logo = [[

   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ 
   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ 
   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ 
   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ 
   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ 
   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ 

    ]]

local function getGreeting(name)
  local tableTime = os.date("*t")
  local datetime = os.date(" %Y-%m-%d   %H:%M:%S")
  local hour = tableTime.hour
  local greetingsTable = {
    [1] = "  Sleep well",
    [2] = "  Good morning",
    [3] = "  Good afternoon",
    [4] = "  Good evening",
    [5] = "󰖔  Good night",
  }
  local greetingIndex = 0
  if hour == 23 or hour < 7 then
    greetingIndex = 1
  elseif hour < 12 then
    greetingIndex = 2
  elseif hour >= 12 and hour < 18 then
    greetingIndex = 3
  elseif hour >= 18 and hour < 21 then
    greetingIndex = 4
  elseif hour >= 21 then
    greetingIndex = 5
  end
  return datetime .. "\t\t" .. greetingsTable[greetingIndex] .. ", " .. name
end

local userName = "Eilish"
local greeting = getGreeting(userName)
local function header()
  return {
    { logo, hl = "header" },
    { greeting, hl = "header" },
  }
end

local function keys()
  return {
    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
    { icon = " ", key = "w", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
    { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
    { icon = " ", key = "g", desc = "Git Files", action = ":lua Snacks.dashboard.pick('git_files')" },
    { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
    { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
  }
end

local version = " 󰥱 v" .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch .. "\t"
local function footer()
  M.lazy_stats = M.lazy_stats and M.lazy_stats.startuptime > 0 and M.lazy_stats or require("lazy.stats").stats()
  local ms = (math.floor(M.lazy_stats.startuptime * 100 + 0.5) / 100)
  return {
    align = "center",
    text = {
      { version, hl = "footer" },
      { "  Loaded ", hl = "footer" },
      { M.lazy_stats.loaded .. "/" .. M.lazy_stats.count, hl = "special" },
      { " plugins in ", hl = "footer" },
      { ms .. "ms", hl = "special" },
    },
  }
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    styles = {
      notification = { border = "rounded" },
      notification_history = { border = "rounded", width = 0.9, height = 0.9, minimal = true },
      snacks_image = {
        border = "rounded",
      },
    },
    dashboard = {
      enabled = true,
      preset = {
        header = header(),
        keys = keys(),
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
        {
          pane = 2,
          { section = "terminal", cmd = "cmatrix", hl = "header", padding = 1, indent = 1, height = 10 },
          {
            section = "terminal",
            cmd = "chafa /Users/vercent/Pictures/Wallpapers/wallhaven-rr7xjq.jpg --format symbols --symbols vhalf --size 60x17 --stretch; sleep .1",
            height = 17,
          },
        },
      },
    },
    notifier = {
      enabled = true,
      border = "rounded",
      timeout = 2000,
    },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    input = { enabled = true },

    -- disabled modules
    words = { enabled = false, debounce = 10, notify_end = false },
  },
  keys = {
    {
      ";z",
      function()
        Snacks.zen()
      end,
      desc = "Toggle Zen Mode",
    },
    {
      ";m",
      function()
        Snacks.zen.zoom()
      end,
      desc = "Toggle Zoom",
    },
    {
      ";l",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      ";n",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
    {
      "<leader>go",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse",
    },
    {
      "]]",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Next Reference",
      mode = { "n", "t" },
    },
    {
      "[[",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Prev Reference",
      mode = { "n", "t" },
    },
  },
  config = function(_, opts)
    Snacks.dashboard.sections.startup = footer
    require("snacks").setup(opts)
  end,
}
