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
vim.keymap.set('n', '<leader>v', Builtin.git_files)

vim.keymap.set('n', '<leader>G', function()
    Builtin.live_grep({ additional_args = { '--hidden' } })
end, { desc = "Telescope grep hidden" })

vim.keymap.set('n', '<leader>F', function()
    Builtin.find_files({ hidden = true, no_ignore = true })
end, {})

Telescope.setup({
    defaults = {
        scroll_strategy = 'limit',
        -- sorting_strategy = 'ascending',
        -- layout_config = {
        --     prompt_position = 'top',
        -- },
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
