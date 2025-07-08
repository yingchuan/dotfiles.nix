return {
  {
    "nvim-neorg/neorg",
    build = function()
      -- Skip treesitter installation for norg due to compilation issues
      -- Neorg will work without syntax highlighting
    end,
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {}, -- Loads default behaviour
          ["core.concealer"] = {
            config = {
              icon_preset = "basic", -- Use basic icons that don't require treesitter
            },
          }, -- Adds pretty icons to your documents
          ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
              workspaces = {
                notes = "~/notes",
              },
            },
          },
          ["core.keybinds"] = {
            config = {
              default_keybinds = false, -- Disable default keybinds to avoid conflicts
              hook = function(keybinds)
                -- Define only the keybinds you want, avoiding conflicts
                keybinds.map("norg", "n", "<C-s>", "<cmd>Neorg keybind norg core.integrations.telescope.find_linkable<CR>")
                keybinds.map("norg", "n", "<Leader>nn", "<cmd>Neorg workspace notes<CR>")
                keybinds.map("norg", "n", "<Leader>nc", "<cmd>Neorg toggle-concealer<CR>")
                
                -- Add more custom keybinds as needed, avoiding the conflicting ones
              end,
            },
          },
        },
      })
    end,
  },
}
