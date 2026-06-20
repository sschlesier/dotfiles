return {
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("everforest")
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "#4f5a6e" })
    end,
  },
}
