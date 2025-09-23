-- Neovim Lua configuration

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local uv = vim.uv or vim.loop
local fn = vim.fn
local opt = vim.opt
local g = vim.g

local data_home = vim.env.XDG_DATA_HOME or (vim.env.HOME .. '/.local/share')
local cache_home = vim.env.XDG_CACHE_HOME or (vim.env.HOME .. '/.cache')

local function ensure_dir(path, mode)
  if fn.isdirectory(path) == 0 then
    fn.mkdir(path, 'p', mode or 448) -- 0700
  end
end

ensure_dir(data_home .. '/vim')
ensure_dir(data_home .. '/vim/spell')
ensure_dir(data_home .. '/vim/view')
ensure_dir(cache_home .. '/vim/backup')
ensure_dir(cache_home .. '/vim/swap')
ensure_dir(cache_home .. '/vim/undo')

g.netrw_home = data_home .. '/vim'
opt.viewdir = data_home .. '/vim/view'
opt.backupdir = cache_home .. '/vim/backup'
opt.directory = cache_home .. '/vim/swap'
opt.undodir = cache_home .. '/vim/undo'
opt.undofile = true

if vim.env.FZF_HOME and vim.env.FZF_HOME ~= '' then
  opt.rtp:append(vim.env.FZF_HOME)
end

local lazypath = fn.stdpath('data') .. '/lazy/lazy.nvim'
if not uv.fs_stat(lazypath) then
  fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', lazypath,
  })
end
opt.rtp:prepend(lazypath)

require('lazy').setup({
  { 'Shatur/neovim-ayu' },
  { 'aklt/plantuml-syntax' },
  { 'blueyed/vim-diminactive' },
  { 'bronson/vim-trailing-whitespace' },
  { 'dense-analysis/ale' },
  { 'editorconfig/editorconfig-vim' },
  { 'junegunn/fzf', build = './install --bin' },
  { 'junegunn/fzf.vim', dependencies = { 'junegunn/fzf' } },
  { 'sirtaj/vim-openscad' },
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-unimpaired' },
}, {
  defaults = { lazy = false },
  checker = { enabled = false },
})

pcall(function()
  require('ayu').setup({ overrides = {} })
end)

opt.termguicolors = true
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'
opt.fileformat = 'unix'
opt.fileformats = { 'unix', 'dos', 'mac' }
opt.fixendofline = true
opt.autoread = true
opt.autowrite = true
opt.autoindent = true
opt.smarttab = true
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.backspace = { 'indent', 'eol', 'start' }
opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.completeopt = { 'menu', 'menuone' }
opt.pumheight = 10
opt.inccommand = 'nosplit'
opt.showcmd = true
opt.showmatch = false
opt.lazyredraw = true
opt.modeline = false
opt.hidden = true
opt.errorbells = false
opt.visualbell = false
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.splitright = true
opt.splitbelow = true
opt.laststatus = 2
opt.number = true
opt.relativenumber = false
opt.cursorline = false
opt.cursorcolumn = false
opt.scrolloff = 3
opt.updatetime = 250
opt.showmode = false
opt.ruler = false
opt.signcolumn = 'yes'
opt.list = false
opt.listchars = {
  eol = '¬',
  tab = '>·',
  trail = '~',
  extends = '>',
  precedes = '<',
  space = '␣',
}

vim.cmd('syntax enable')
vim.cmd('filetype plugin indent on')

g.diminactive_use_syntax = 0
g.diminactive_use_colorcolumn = 1

local function apply_custom_highlights()
  local transparent = { bg = 'none' }
  vim.api.nvim_set_hl(0, 'Normal', transparent)
  vim.api.nvim_set_hl(0, 'NonText', transparent)
  local visual_bg = vim.o.background == 'light' and '#d0d7df' or '#3e4b59'
  vim.api.nvim_set_hl(0, 'Visual', { bg = visual_bg })
  vim.api.nvim_set_hl(0, 'SpecialKey', { fg = '#e7c547', ctermfg = 220 })
end

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = apply_custom_highlights,
})

local theme_file = fn.expand('$XDG_DATA_HOME/theme_mode')

local function apply_theme()
  local mode = 'dark'
  if fn.filereadable(theme_file) == 1 then
    local contents = fn.readfile(theme_file, '', 1)
    if contents[1] == 'light' then
      mode = 'light'
    end
  end
  vim.o.background = mode
  g.ayucolor = mode
  local ok = pcall(vim.cmd.colorscheme, 'ayu')
  if ok then
    apply_custom_highlights()
  end
end

local watcher
local function watch_theme_file()
  if fn.filereadable(theme_file) == 0 then
    return
  end
  watcher = watcher or uv.new_fs_event()
  if not watcher then
    return
  end
  watcher:start(theme_file, {}, vim.schedule_wrap(function()
    apply_theme()
    watcher:stop()
    watch_theme_file()
  end))
end

apply_theme()
watch_theme_file()

local yank_command
local uname = uv.os_uname().sysname
if uname == 'Darwin' then
  yank_command = { 'pbcopy' }
elseif uname == 'Linux' then
  yank_command = { 'xclip', '-selection', 'clipboard' }
end

if yank_command then
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      if vim.v.event.operator ~= 'y' then
        return
      end
      local contents = vim.v.event.regcontents or {}
      local text = table.concat(contents, '\n')
      if text == '' then
        return
      end
      local job = fn.jobstart(yank_command, { stdin = 'pipe', detach = true })
      if job > 0 then
        fn.chansend(job, text .. '\n')
        fn.chanclose(job, 'stdin')
      end
    end,
  })
else
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      if vim.v.event.operator == 'y' then
        local text = fn.getreg('0')
        if text ~= '' then
          fn.setreg('+', text)
        end
      end
    end,
  })
end

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 120 })
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  command = [[%s/\s\+$//e]],
})

local map = vim.keymap.set
local silent = { silent = true, noremap = true }

map('n', '<C-s>', function()
  vim.cmd('update')
end, silent)
map('v', '<C-s>', '<C-c><Cmd>update<CR>', silent)
map('i', '<C-s>', '<Esc><Cmd>update<CR>', silent)

map('n', '<leader>l', ':nohlsearch<CR>', silent)
map('n', '<leader>q', ':q<CR>', silent)
map('n', '<leader>w', ':set list!<CR>', silent)
map('n', '<leader>o', ':Files<CR>', silent)
map('n', '<leader>O', ':Files!<CR>', silent)
map('n', '<leader>e', function()
  local line = vim.api.nvim_get_current_line()
  vim.cmd(line)
end, silent)
map({ 'n', 'v' }, '<leader><leader>', ':', silent)

map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

map({ 'n', 'v' }, '<Up>', 'gk', { noremap = true })
map({ 'n', 'v' }, '<Down>', 'gj', { noremap = true })
map('n', 'j', 'gj', { noremap = true })
map('n', 'k', 'gk', { noremap = true })

map('n', 'Y', 'y$', { noremap = true })
map('n', 'Q', '@@', { noremap = true })
map('v', '.', ':normal .<CR>', silent)


vim.api.nvim_create_autocmd('User', {
  pattern = 'LazyDone',
  once = true,
  callback = apply_theme,
})
