vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("trailing_whitespace", { clear = true }),
  pattern = "*",
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})
