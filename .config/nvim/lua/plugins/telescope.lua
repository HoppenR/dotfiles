local Telescope = require('telescope')
local Actions = require('telescope.actions')
local Builtin = require('telescope.builtin')

-- Global keybinds
vim.keymap.set('n', '<leader><leader>', Builtin.builtin)
vim.keymap.set('n', '<leader>b', Builtin.buffers)
vim.keymap.set('n', '<leader>f', Builtin.find_files)
vim.keymap.set('n', '<leader>g', Builtin.live_grep)
vim.keymap.set('n', '<leader>i', Builtin.lsp_implementations)
vim.keymap.set('n', '<leader>l', Builtin.diagnostics)
vim.keymap.set('n', '<leader>o', Builtin.oldfiles)
vim.keymap.set('n', '<leader>r', Builtin.lsp_references)
vim.keymap.set('n', '<leader>s', Builtin.lsp_document_symbols)
vim.keymap.set('n', '<leader>t', Builtin.current_buffer_fuzzy_find)
vim.keymap.set('n', '<leader>u', Telescope.extensions.undo.undo)

Telescope.setup({
    defaults = {
        scroll_strategy = 'limit',
        mappings = {
            n = {
                ['<C-d>'] = Actions.results_scrolling_down,
                ['<C-u>'] = Actions.results_scrolling_up,
                ['<Esc>'] = false,
                ['q'] = Actions.close,
            },
            i = {
                ['<C-b>'] = Actions.preview_scrolling_up,
                ['<C-d>'] = Actions.close,
                ['<C-f>'] = Actions.preview_scrolling_down,
                ['<C-u>'] = false,
            },
        },
    },
    pickers = {
        buffers = {
            mappings = {
                n = {
                    ['dd'] = Actions.delete_buffer,
                },
            },
        },
    },
})
