return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "zls" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "zig" },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, {
        zig = { "zigfmt" },
      })

      opts.formatters = vim.tbl_extend("force", opts.formatters or {}, {
        zigfmt = {
          command = "zig",
          args = { "fmt", "--stdin" },
          stdin = true,
        },
      })
    end,
  },
}
