-- ~/.config/nvim/lua/plugins/snacks-image.lua
return {
  {
    "folke/snacks.nvim",
    opts = {
      image = {
        force = true, -- 即便終端不支援，也要嘗試顯示
        doc = {
          enabled = true, -- 文件中啟用
          inline = false, -- 關掉行內（placeholders 不支援）
          float = true, -- 改用浮動視窗
          max_width = 100, -- 可自行調整尺寸
          max_height = 40,
        },
      },
    },
  },
}
