local opt = vim.opt

-- Search
opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Editing
opt.autoindent = true
opt.backspace = { "indent", "eol", "start" }
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.smarttab = true
opt.fileformat = "unix"
opt.fileformats = { "unix", "dos", "mac" }

-- UI
opt.laststatus = 2
opt.showcmd = true
opt.number = true
opt.relativenumber = false
opt.cursorcolumn = false
opt.cursorline = false
opt.lazyredraw = true
opt.scrolloff = 3
opt.inccommand = "nosplit"
opt.errorbells = false
opt.showmatch = false
opt.termguicolors = true

-- Completion
opt.completeopt = { "menu", "menuone" }
opt.pumheight = 10

-- Visible whitespace (toggled with <leader>w)
opt.listchars = {
  eol = "¬",
  tab = ">·",
  trail = "~",
  extends = ">",
  precedes = "<",
  space = "␣",
}
opt.list = false

-- Windows & buffers
opt.splitright = true
opt.splitbelow = true
opt.autowrite = true
opt.autoread = true
opt.hidden = true
opt.updatetime = 250

-- Files
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.modeline = false

-- nvim handles system clipboard natively; replaces manual pbcopy/xclip autocmd
-- note: all yank/delete/change ops go to system clipboard (not just y)
opt.clipboard = "unnamedplus"
