return {
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      -- Force use of a C compiler so the -std=c11 flag is accepted
      require("nvim-treesitter.install").compilers = { "clang", "gcc", "cc" }
      -- optional: also pin the environment variable
      vim.env.CC = "clang"
      
      -- Fix for norg parser compilation issues
      require("nvim-treesitter.install").prefer_git = false
      
      -- Skip norg parser configuration due to persistent compilation issues
    end,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "gotmpl",
          "go",
          "c",
          "zig",
          "lua",
          "vim",
          "cpp",
          "python",
          "devicetree",
          "bitbake",
          "awk",
          "jq",
          "llvm",
          "tmux",
          "latex",
          "typst",
          "css",
          -- "norg", -- Disable auto-install due to compilation issues
          "scss",
          "svelte",
          "vue",
          "nix",
        })
      end
    end,
  },
}
