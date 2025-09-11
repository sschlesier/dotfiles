-- File watcher using Neovim's native API
local theme_file = vim.fn.expand('$XDG_DATA_HOME/theme_mode')

local function apply_theme()
    if vim.fn.filereadable(theme_file) == 1 then
        local theme_mode = vim.fn.readfile(theme_file, '', 1)[1]
        if theme_mode == 'light' then
            vim.o.background = 'light'
            vim.g.ayucolor = 'light'
        else
            vim.o.background = 'dark'
            vim.g.ayucolor = 'dark'
        end
        vim.cmd('colorscheme ayu')
    end
end

-- Apply on startup
apply_theme()

-- File watcher (Neovim only)
local w = vim.loop.new_fs_event()
local function watch_file(fname)
    w:start(fname, {}, vim.schedule_wrap(function()
        apply_theme()
        -- Restart watcher (required for some file systems)
        w:stop()
        watch_file(fname)
    end))
end

-- Start watching
if vim.fn.filereadable(theme_file) == 1 then
    watch_file(theme_file)
end
