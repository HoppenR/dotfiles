-- Local keybinds
local function default_neorg_binds()
    local ldr = vim.g.maplocalleader
    vim.keymap.set('n', ldr .. 'J', '<cmd>Neorg journal tomorrow<CR>', {})
    vim.keymap.set('n', ldr .. 'O', '<cmd>Neorg journal toc open<CR>', {})
    vim.keymap.set('n', ldr .. 'j', '<cmd>Neorg journal today<CR>', {})
    vim.keymap.set('n', ldr .. 'w', '<cmd>Neorg index<CR>', {})
    vim.keymap.set('n', ldr .. 'y', '<cmd>Neorg journal yesterday<CR>', {})
    vim.keymap.set('n', ldr .. 'c', '<cmd>Neorg journal custom<CR>', {})
    -- Don't autowrap
    vim.opt_local.formatoptions:remove('t')
end

vim.keymap.set('n', vim.g.maplocalleader .. 'p', '<cmd>Neorg workspace personal<CR>')
vim.keymap.set('n', vim.g.maplocalleader .. 's', '<cmd>Neorg workspace school<CR>')
-- vim.keymap.set('n', vim.g.maplocalleader, '<Nop>')

return {
    "neorg",
    cmd = "Neorg",
    ft = "norg",
    opt = true,
    after = function()
        require('neorg').setup({
            load = {
                ['core.concealer'] = {
                    config = {
                        folds = false,
                        icon_preset = 'diamond',
                    },
                },
                ['core.defaults'] = {},
                ['core.dirman'] = {
                    config = {
                        workspaces = {
                            personal = '~/Documents/norg/personal/',
                            school = '~/Documents/norg/school/',
                        },
                    },
                },
                ['core.export'] = {},
                ['core.journal'] = {
                    config = {
                        strategy = 'nested',
                        workspace = 'school',
                    },
                },
                ['core.qol.toc'] = {
                    config = {
                        close_after_use = true,
                    },
                },
                ['core.ui.calendar'] = {},
            },
        })
        default_neorg_binds()
    end,
}
