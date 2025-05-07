return {
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "ga", "<cmd>Lspsaga code_action<CR>", desc = "Lspsaga Code Action" },
      { "gf", "<cmd>Lspsaga finder<CR>", desc = "Lspsaga Finder" },
      { "go", "<cmd>Lspsaga outline<CR>", desc = "Lspsaga Outline" },
      { "gR", "<cmd>Lspsaga rename<CR>", desc = "Lspsaga Rename" },
      { "gp", "<cmd>Lspsaga peek_definition<CR>", desc = "Lspsaga Peek Definition" },
      { "gd", "<cmd>Lspsaga goto_definition<CR>", desc = "Lspsaga Goto Definition" },
      { "gl", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Lspsaga Show Line Diagnostics" },
      { "gj", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Lspsaga Diagnsotic Jump Next" },
      { "gk", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Lspsaga Diagnsotic Jump Previous" },
      { "gh", "<cmd>Lspsaga hover_doc<CR>", desc = "Lspsaga Hover" },
      {
        "<leader>gh",
        function()
          local win = require("lspsaga.window")
          local old_new_float = win.new_float
          win.new_float = function(self, float_opt, enter, force)
            local window = old_new_float(self, float_opt, enter, force)
            local _, winid = window:wininfo()
            vim.api.nvim_set_current_win(winid)

            win.new_float = old_new_float
            return window
          end

          vim.cmd("Lspsaga hover_doc")
        end,
        desc = "hover doc",
        silent = true,
      },
    },
    opts = {
      ui = {
        theme = "round",
        title = true,
        kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
        -- Border type can be single, double, rounded, solid, shadow.
        border = "rounded",
        winblend = 0,
        expand = "",
        collapse = "",
        preview = " ",
        code_action = "💡",
        diagnostic = "🐞",
        incoming = "󰏷 ",
        outgoing = "󰏻 ",
        hover = " ",
        colors = require("catppuccin.groups.integrations.lsp_saga").custom_colors(),
      },
      -- hover
      hover = {
        open_link = "gx",
      },
      -- winbar
      symbol_in_winbar = {
        enable = true,
        show_file = true,
        separator = " › ",
        hide_keyword = false,
        folder_level = 2,
        respect_root = false,
        color_mode = true,
      },
      -- lightbulb
      lightbulb = {
        enable_in_insert = false,
        sign = false,
        sign_priority = 40,
        virtual_text = false,
      },
      -- diagnostic
      diagnostic = {
        show_code_action = true,
        show_source = true,
        jump_num_shortcut = true,
        -- 1 is max
        max_width = 0.7,
        custom_fix = nil,
        custom_msg = nil,
        text_hl_follow = false,
        keys = { exec_action = "o", quit = "q", go_action = "g" },
      },
      -- finder icons
      finder_icons = { def = "  ", ref = "󰵚 ", link = "󰴜 " },
      -- finder
      finder = {
        jump_to = "p",
        edit = { "o", "<CR>" },
        tabe = "t",
        quit = { "q", "<ESC>" },
      },
      -- show outline
      outline = {
        win_position = "right",
        win_with = "",
        win_width = 40,
        auto_enter = true,
        detail = false,
        auto_preview = false,
        virt_text = "┃",
        keys = { jump = "o", toggle_or_jump = "u", quit = "q" },
        -- auto refresh when change buffer
        auto_refresh = true,
      },
      -- difinition
      definition = {
        edit = "<S-c>o",
        vsplit = "<S-c>v",
        split = "<S-c>i",
        tabe = "<S-c>t",
        quit = "q",
        close = "<Esc>",
      },
      -- code action
      code_action = {
        num_shortcut = true,
        extend_gitsigns = true,
        keys = {
          -- string | table type
          quit = "q",
          exec = "<CR>",
        },
      },
      -- rename
      rename = {
        in_select = true,
        auto_save = true,
        keys = {
          quit = "q",
          exec = "<CR>",
          select = "x",
        },
      },
      request_timeout = 3000,
    },
  },
}
