--
-- ~/.config/nvim/init.lua
--

vim.cmd.filetype({ args = { 'plugin', 'indent', 'on' } })
vim.cmd.syntax('on')

--- VARIABLES
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = ' '
vim.g.maplocalleader = 's'

if vim.fn.has('gui_running') == 1 then
    vim.opt.guifont = { 'monospace', ':h15' }
else
    vim.o.termguicolors = true
end

--- PLUGINS
require('rocks-nvim')

--- COLORSCHEME
vim.cmd.colorscheme('wal')

--- FUNCTIONS
local fns = require('functions')

--- BOOLEAN OPTIONS
vim.o.autochdir = true
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.fileignorecase = true
vim.o.ignorecase = true
vim.o.list = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.ruler = false
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.title = true
vim.o.undofile = true
vim.o.wrap = false

--- STRING / NUMBER OPTIONS
vim.o.clipboard = 'unnamed'
vim.o.colorcolumn = '80'
vim.o.conceallevel = 2
vim.o.foldmethod = 'marker'
vim.o.laststatus = 3
vim.o.pumblend = 0
vim.o.shiftwidth = 0
vim.o.signcolumn = 'no'
vim.o.shortmess = 'AFOTWiost'
vim.o.statusline = table.concat({
    -- Left
    ' ',
    '%F', -- Long filename
    '%=', -- Separate sections
    -- Right
    ' 󱑜 %{&fileencoding} ',
    '  %{&filetype} ',
    '  %{&fileformat} ',
    ' %l %v ',
    ' %p%% ',
})
vim.o.tabstop = 4
vim.o.textwidth = 80
vim.o.timeoutlen = 500
vim.o.titlestring = '%F - NVIM'
vim.o.ttimeoutlen = 50
vim.o.updatetime = 500
vim.o.winbar = '%=%f %r%m%='
vim.o.winborder = 'rounded'
vim.o.winblend = 0

--- LIST OPTIONS
vim.opt.cinoptions = { ':0', 'g0', '(0', 'W4', 'l1' }
vim.opt.completeopt = { 'menuone', 'noinsert', 'popup' }
vim.opt.foldmarker = { '{{{', '}}}' }
-- NOTE: vim.opt_local.listchars['leadmultispace'] is set in AutoSetIndentChars
vim.opt.listchars = { extends = '▸', nbsp = '◇', tab = '│ ', trail = '∘' }
vim.opt.matchpairs = { '(:)', '{:}', '[:]', '<:>' }

--- MAPPINGS
vim.keymap.set('n', '<C-S-j>', '<cmd>move+1<CR>')
vim.keymap.set('n', '<C-S-k>', '<cmd>move-2<CR>')
vim.keymap.set('n', '<C-w>N', vim.cmd.vnew, { desc = "Open new vertical split" })
vim.keymap.set('n', '<C-w>n', vim.cmd.new, { desc = "Open new horizontal split" })
vim.keymap.set('n', '<F1>', '<cmd>setlocal spell!<CR>')
vim.keymap.set('n', '<M-S-a>', vim.treesitter.inspect_tree, { desc = 'Show language tree' })
vim.keymap.set('n', '<M-S-n>', '<cmd>cnext<CR>')
vim.keymap.set('n', '<M-S-p>', '<cmd>cprevious<CR>')
vim.keymap.set('n', '<M-a>', vim.show_pos, { desc = 'Show language items' })
vim.keymap.set('n', '<M-q>', vim.cmd.terminal, { desc = 'Open terminal window' })
vim.keymap.set('n', '-', ':set ')
vim.keymap.set('n', '_', ':lua ')
vim.keymap.set('n', 'ä', vim.cmd.LspInfo, { desc = 'Open LSP info' })
vim.keymap.set('v', '<C-S-j>', ":move '>+1<CR>gv", { desc = 'Move visual selection down' })
vim.keymap.set('v', '<C-S-k>', ":move '<-2<CR>gv", { desc = 'Move visual selection up' })
vim.keymap.set('v', '¤', 'c<C-r>=<C-r>"<CR><Esc>', { desc = 'Evaluate highlighted expr' })

-- Enter should not accept the selected popupmenu entry, only <C-y> should
vim.keymap.set("i", "<CR>",
    function()
        if vim.fn.pumvisible() == 1 then
            return "<C-e><CR>"
        else
            return "<CR>"
        end
    end,
    { expr = true }
)

-- Viewport
vim.keymap.set('n', '<Down>', '<C-e>')
vim.keymap.set('n', '<Left>', 'zh')
vim.keymap.set('n', '<Right>', 'zl')
vim.keymap.set('n', '<Up>', '<C-y>')

-- Resize
vim.keymap.set('n', '<S-Down>', '<C-w>-')
vim.keymap.set('n', '<S-Left>', '<C-w><')
vim.keymap.set('n', '<S-Right>', '<C-w>>')
vim.keymap.set('n', '<S-Up>', '<C-w>+')

-- Braces
-- fns.set_insert_brace_bindings()

-- Graphical menu deletions
if not vim.g.removed_menu_options then
    vim.cmd.aunmenu('PopUp.-1-')
    vim.cmd.aunmenu('PopUp.How-to\\ disable\\ mouse')
    vim.g.removed_menu_options = true
end

--- AUTOCOMMANDS
-- Run makeprg if a makefile is in the same directory on buffer write
local AutoMake = vim.api.nvim_create_augroup('AutoMake', {
    clear = true,
})
vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = { '*.c', '*.cc', '*.cpp', '*.go', '*.rs' },
    group = AutoMake,
    callback = fns.make_if_makefile_exist,
})

-- Set settings for built-in neovim terminals
local TerminalSettings = vim.api.nvim_create_augroup('TerminalSettings', {
    clear = true,
})
vim.api.nvim_create_autocmd('TermOpen', {
    pattern = 'term://*',
    group = TerminalSettings,
    callback = fns.set_terminal_settings,
})

-- Dynamically set the indent chars to the shiftwidth value
-- once on a new buffer and every time a relevant option is changed
local AutoSetIndentChars = vim.api.nvim_create_augroup('AutoSetIndentChars', {
    clear = true,
})
vim.api.nvim_create_autocmd('OptionSet', {
    pattern = { 'shiftwidth' },
    group = AutoSetIndentChars,
    callback = fns.set_lead_indent_chars,
})
vim.api.nvim_create_autocmd('BufWinEnter', {
    pattern = '*',
    group = AutoSetIndentChars,
    callback = fns.set_lead_indent_chars,
})

local TextYankHighlight = vim.api.nvim_create_augroup('highlight_yank', {
    clear = true,
})
vim.api.nvim_create_autocmd('TextYankPost', {
    group = TextYankHighlight,
    desc = 'Hightlight selection on yank',
    pattern = '*',
    callback = function(args)
        vim.hl.on_yank({
            higroup = 'Search',
            -- timeout = 150,
            on_visual = false,
            -- event = args.event,
        })
    end,
})
