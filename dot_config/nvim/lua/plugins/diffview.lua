return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory" }, -- Lazy-load
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>",          desc = "Diffview: project diff" },
    { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: file history" },
  },
  opts = {}, -- 使用預設設定
}
