return {
  {
    "nvim-treesitter/nvim-treesitter",
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
          "norg",
          "scss",
          "svelte",
          "vue",
          "nix",
        })
        -- Force use of a C compiler so the -std=c11 flag is accepted
        require("nvim-treesitter.install").compilers = { "clang", "gcc", "cc" }
      end
    end,
  },
}
