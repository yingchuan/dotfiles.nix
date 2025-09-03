-- Ensure gopls is installed (LazyVim Go extra doesn't include it by default)
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "gopls" },
    },
  },
}