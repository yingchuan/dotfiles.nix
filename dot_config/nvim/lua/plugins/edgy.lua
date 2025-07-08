return {
  "folke/edgy.nvim",
  event = "VeryLazy",
  init = function()
    vim.opt.laststatus = 3
    vim.opt.splitkeep = "screen"
  end,
  opts = {
    left = {
      -- Neo-tree filesystem always takes half the screen height
      {
        title = "Neo-Tree",
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source == "filesystem"
        end,
        size = { width = 0.2, height = 0.5 },
      },
      -- any other neo-tree windows
      "neo-tree",
    },
    bottom = {
      {
        ft = "snacks_terminal",
        title = "Snacks Terminal",
        size = { height = 0.2 },
        filter = function(_, win)
          return vim.w[win].snacks_win
            and vim.w[win].snacks_win.position == "bottom"
            and vim.w[win].snacks_win.relative == "editor"
            and not vim.w[win].trouble_preview
        end,
      },
    },
  },
}
