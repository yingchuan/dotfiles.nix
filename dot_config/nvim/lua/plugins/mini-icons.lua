return {
  "echasnovski/mini.nvim",          -- provides mini.icons and many other mini-modules
  version = false,                  -- always use latest
  event = "VeryLazy",               -- load on first “require”
  dependencies = {                  -- make sure icon provider is present
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- initialise only the icons module; other mini.* stay disabled
    require("mini.icons").setup()   -- use default icon set
  end,
}
