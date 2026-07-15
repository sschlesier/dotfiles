return {
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      local function apply()
        vim.cmd.colorscheme("everforest")
        if vim.o.background == "dark" then
          vim.api.nvim_set_hl(0, "CursorLine", { bg = "#4f5a6e" })
        end
      end

      apply()

      vim.api.nvim_create_autocmd("OptionSet", {
        pattern = "background",
        callback = apply,
      })
    end,
  },
}
