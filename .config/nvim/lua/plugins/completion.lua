local Blinkcmp = require('blink.cmp')
-- Global keybinds
vim.keymap.set({ 'i', 's' }, '<C-h>', function() vim.snippet.jump(-1) end)
vim.keymap.set({ 'i', 's' }, '<C-l>', function() vim.snippet.jump(1) end)

Blinkcmp.setup({
    signature = {
        enabled = true,
        window = {
            show_documentation = false,
            border = 'rounded',
        },
    },
    completion = {
        list = {
            selection = {
                auto_insert = true,
            }
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
            window = {
                border = 'rounded',
            },
        },
        menu = {
            border = 'rounded',
            draw = { gap = 2 },
        },
    },
})
