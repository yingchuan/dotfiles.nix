-- Small helper module just to ensure the icon set is available
return {
  "nvim-tree/nvim-web-devicons",
  lazy = true,          -- load on-demand (most plugins require it automatically)
  opts = {},            -- use default icon set; no extra config needed
}
