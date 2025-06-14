return {
  "folke/noice.nvim",
  opts = function(_, opts)
    opts.cmdline = {
      enabled = true, -- 要用 noice 處理 :cmdline
      view = "cmdline", -- 用底部單行，而不是預設 cmdline_popup
    }

    opts.presets = vim.tbl_extend("force", opts.presets or {}, {
      bottom_search = true, -- / ? 搜尋時也用底部列
      command_palette = false, -- 關掉 command-palette 浮窗
    })
  end,
}
