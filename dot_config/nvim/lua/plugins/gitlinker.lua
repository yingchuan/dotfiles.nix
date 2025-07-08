return {
  "ruifm/gitlinker.nvim",
  event = "VeryLazy",          -- 延遲載入
  opts  = {},                  -- 預設即可
  keys = {
    { "<leader>gy", "<cmd>GitLink<cr>", desc = "Yank git permalink" },
  },
}
