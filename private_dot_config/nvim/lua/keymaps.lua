local map = vim.keymap.set
local s = { silent = true }

-- Save
map({ "n", "v" }, "<C-s>", ":update<CR>", s)
map("i", "<C-s>", "<Esc>:update<CR>", s)

-- Clear search highlight
map("n", "<leader>l", ":nohlsearch<CR>", s)

-- Close buffer
map("n", "<leader>q", ":q<CR>", s)

-- Window navigation
map("n", "<C-h>", "<C-w>h", s)
map("n", "<C-j>", "<C-w>j", s)
map("n", "<C-k>", "<C-w>k", s)
map("n", "<C-l>", "<C-w>l", s)

-- Visual dot repeat
map("v", ".", ":normal .<CR>", s)

-- Toggle visible whitespace
map("n", "<leader>w", ":set list!<CR>", s)

-- Move by display lines (respects wrapping)
map({ "n", "v" }, "<Up>", "gk", s)
map({ "n", "v" }, "<Down>", "gj", s)
map({ "n", "v" }, "j", "gj", s)
map({ "n", "v" }, "k", "gk", s)

-- Yank to end of line (consistent with D and C)
map("n", "Y", "y$", s)

-- Repeat last macro
map("n", "Q", "@@", s)

-- Run current line as ex command
map("n", "<leader>e", ':exe getline(line("."))<CR>', s)

-- Enter ex mode
map({ "n", "v" }, "<leader><leader>", ":", { silent = false })

-- fzf-lua
local fzf = function(method) return function() require("fzf-lua")[method]() end end
map("n", "<leader>o", fzf("files"), s)
map("n", "<leader>O", function() require("fzf-lua").files({ fullscreen = true }) end, s)
map("c", "<C-p>", fzf("command_history"), s)
map("c", "<C-_>", fzf("search_history"), s)
map("n", "<leader>y", fzf("oldfiles"), s)
map("n", "<leader>b", fzf("buffers"), s)
map("n", "<leader>`", fzf("marks"), s)
map("n", "<leader>L", fzf("blines"), s)
map("n", "<F1>", fzf("help_tags"), s)
map("i", "<F1>", fzf("help_tags"), s)
map({ "n", "v" }, "<leader>;", fzf("commands"), s)
map("n", "<leader>f", fzf("live_grep"), s)
map({ "n", "v" }, "<leader>s", fzf("grep_cword"), s)

-- Fugitive conflict resolution
map("n", "<leader>gd", ":Gvdiff<CR>", s)
map("n", "gdh", ":diffget //2<CR>", s)
map("n", "gdl", ":diffget //3<CR>", s)
