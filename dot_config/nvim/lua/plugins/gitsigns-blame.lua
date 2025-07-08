return {
  "lewis6991/gitsigns.nvim",
  opts = function(_, opts)
    -- show blame on the current line by default
    opts.current_line_blame = true

    -- preserve any existing on_attach then add our keymap
    local orig_attach = opts.on_attach
    opts.on_attach = function(bufnr)
      if orig_attach then orig_attach(bufnr) end
      vim.keymap.set(
        "n",
        "<leader>gn",
        require("gitsigns").toggle_current_line_blame,
        { buffer = bufnr, desc = "Toggle line blame" }
      )
    end
  end,
}
