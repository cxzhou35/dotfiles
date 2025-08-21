return {
  "folke/snacks.nvim",
  opts = {
    indent = {
      enabled = true,
      indent = {
        char = "┆",
        only_scope = false,
        only_current = true,
        hl = "SnacksIndent",
      },
      animate = {
        duration = {
          step = 10,
          duration = 100,
        },
      },
      scope = {
        enabled = true,
        priority = 200,
        char = "┊",
        underline = false,
        only_current = true,
        hl = {
          "SnacksIndent1",
          "SnacksIndent2",
          "SnacksIndent3",
          "SnacksIndent4",
          "SnacksIndent5",
          "SnacksIndent6",
          "SnacksIndent7",
          "SnacksIndent8",
        },
      },
      chunk = {
        enabled = false,
        priority = 200,
        only_current = true,
        hl = "SnacksIndentChunk",
      },
    },
  },
}
