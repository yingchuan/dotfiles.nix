-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.gohtml", "*.gotmpl", "*.html", "*.tmpl" },
	callback = function()
		if vim.fn.search("{{.\\+}}", "nw") ~= 0 then
			local buf = vim.api.nvim_get_current_buf()
			vim.api.nvim_buf_set_option(buf, "filetype", "gotmpl")
		end
		vim.bo.filetype = "gotmpl"
	end,
})
