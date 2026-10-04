local function current_buffer_dir()
  local name = vim.api.nvim_buf_get_name(0)
  if name ~= "" then
    return vim.fs.dirname(name)
  end

  return (vim.uv or vim.loop).cwd()
end

return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        ";b",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        ";h",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        ";k",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Key Maps",
      },
      {
        ";f",
        function()
          Snacks.picker.files({ hidden = true })
        end,
        desc = "Find Files (Root Dir)",
      },
      {
        ";s",
        function()
          Snacks.picker.icons()
        end,
        desc = "Icons",
      },
      {
        ";w",
        function()
          Snacks.picker.grep_word()
        end,
        desc = "Grep Words",
      },
      {
        ";o",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent",
      },
      {
        ";r",
        function()
          Snacks.picker.grep()
        end,
        desc = "Search for a string in your current working directory",
      },
      {
        ";e",
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = "Document Diagnostics",
      },
      {
        ";x",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix List",
      },
      {
        ";;",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume the previous picker",
      },
      {
        ";c",
        function()
          Snacks.picker.colorschemes()
        end,
        desc = "Colorschemes",
      },
      {
        ";u",
        function()
          Snacks.picker.undo()
        end,
        desc = "Undo History",
      },
      {
        ";v",
        function()
          Snacks.picker.grep_word()
        end,
        desc = "Visual Grep",
        mode = { "n", "v", "x" },
      },
      {
        "<C-f>",
        function()
          Snacks.picker.explorer({
            cwd = current_buffer_dir(),
            cmd = vim.fn.executable("fd") == 1 and "fd" or nil,
            hidden = true,
            ignored = true,
            follow_file = true,
            focus = "list",
            git_status = true,
            git_untracked = true,
            jump = {
              close = true,
            },
            layout = {
              preset = "dropdown",
              preview = false,
              layout = {
                height = math.min(40, math.max(10, vim.o.lines - 4)),
              },
            },
            win = {
              list = {
                keys = {
                  ["n"] = "explorer_add",
                  ["h"] = "explorer_up",
                  ["."] = "toggle_hidden",
                  ["o"] = "explorer_open",
                  ["r"] = "explorer_rename",
                  ["y"] = "explorer_copy",
                  ["d"] = "explorer_del",
                  ["m"] = "explorer_move",
                  ["<PageUp>"] = "preview_scroll_up",
                  ["<PageDown>"] = "preview_scroll_down",
                  ["/"] = "toggle_focus",
                },
              },
            },
          })
        end,
        desc = "Open File Browser with the path of the current buffer",
      },
    },
  },
}
