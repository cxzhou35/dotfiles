local db = "snacks" -- snacks | alpha | dbn
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
    { icon = " ", key = "r", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
    { icon = " ", key = "o", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
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
  -- NOTE: use Snacks.dashboard now
  {
    "goolord/alpha-nvim",
    enabled = db == "alpha",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
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
        return "\t\t" .. datetime .. "\t" .. greetingsTable[greetingIndex] .. ", " .. name
      end

      local userName = "Chenxu"
      local greeting = getGreeting(userName)
      dashboard.section.header.val = vim.split(logo .. "\n" .. greeting, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
        dashboard.button("b", " " .. " File browser", ":Joshuto <CR>"),
        dashboard.button("r", "󰄉 " .. " Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("c", " " .. " Config", "<cmd> lua require('lazyvim.util').telescope.config_files()() <cr>"),
        dashboard.button("x", " " .. " Lazy Extras", "<cmd> LazyExtras <cr>"),
        dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
      }

      -- set highlight
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          local version = "  󰥱 v" .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
          local plugins = "⚡Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"
          local footer = version .. "\t" .. plugins .. "\n"
          dashboard.section.footer.val = footer
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    enabled = false,
    lazy = false,
    event = "VimEnter",
    opts = function()
      local logo = [[
    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ 
    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ 
    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ 
    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ 
    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ 
    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ 
    ]]

      logo = string.rep("\n", 5) .. logo .. "\n"

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
        return datetime .. "\t\t" .. greetingsTable[greetingIndex] .. ", " .. name .. string.rep("\n", 2)
      end

      local userName = "Chenxu"
      local greeting = getGreeting(userName)

      local opts = {
        theme = "doom",
        hide = {
          statusline = false,
          tabline = false,
          winbar = false,
        },
        config = {
          header = vim.split(logo .. "\n" .. greeting, "\n"),
        -- stylua: ignore
        center = {
          { action = 'lua LazyVim.pick()()',                     desc = " Find File",       icon = " ", key = "f" },
          { action = "ene | startinsert",                        desc = " New File",        icon = " ", key = "n" },
          { action = 'lua LazyVim.pick("oldfiles")()',           desc = " Recent Files",    icon = " ", key = "r" },
          { action = 'lua LazyVim.pick("live_grep")()',          desc = " Find Text",       icon = " ", key = "g" },
          { action = 'lua LazyVim.pick.config_files()()',        desc = " Config",          icon = " ", key = "c" },
          -- { action = 'lua require("persistence").load()',        desc = " Restore Session", icon = "󰄉 ", key = "s" },
          { action = "Lazy",                                     desc = " Lazy",            icon = "󰒲 ", key = "l" },
          { action = "qa",                                       desc = " Quit",            icon = " ", key = "q" },
        },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            local version = "  󰥱 v"
              .. vim.version().major
              .. "."
              .. vim.version().minor
              .. "."
              .. vim.version().patch
            local plugins = "⚡Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"
            local footer = version .. "\t" .. plugins
            return { footer }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      return opts
    end,
  },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        enabled = db == "snacks",
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
              cmd = "chafa '/Users/vercent/Pictures/Wallpapers/Steings;Gate/851009.png' -f symbols --symbols vhalf --animate on --size 60x17 --stretch; sleep .1",
              height = 17,
            },
          },
        },
      },
    },
    config = function(_, opts)
      Snacks.dashboard.sections.startup = footer
      require("snacks").setup(opts)
    end,
  },
}
