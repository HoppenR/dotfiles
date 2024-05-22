-- Local keybinds
local function default_neorg_binds(keybinds)
    local ldr = vim.g.neorg_leader
    keybinds.map('norg', 'n', ldr .. 'J', '<cmd>Neorg journal tomorrow<CR>')
    keybinds.map('norg', 'n', ldr .. 'O', '<cmd>Neorg journal toc open<CR>')
    keybinds.map('norg', 'n', ldr .. 'j', '<cmd>Neorg journal today<CR>')
    keybinds.map('norg', 'n', ldr .. 'w', '<cmd>Neorg index<CR>')
    keybinds.map('norg', 'n', ldr .. 'y', '<cmd>Neorg journal yesterday<CR>')
end

-- Return Lazy config
return {
    'nvim-neorg/neorg',
    cmd = 'Neorg',
    dependencies = {
        'vhyrro/luarocks.nvim',
    },
    ft = 'norg',
    init = function()
        -- Global keybinds
        vim.keymap.set('n', vim.g.neorg_leader .. 'p', '<cmd>Neorg workspace personal<CR>')
        vim.keymap.set('n', vim.g.neorg_leader .. 's', '<cmd>Neorg workspace school<CR>')
        vim.keymap.set('n', vim.g.neorg_leader, '<Nop>')
    end,
    lazy = true,
    opts = {
        load = {
            ['core.completion'] = {
                config = {
                    engine = 'nvim-cmp',
                    name = '[Norg]',
                },
            },
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
            ['core.integrations.nvim-cmp'] = {},
            ['core.journal'] = {
                config = {
                    strategy = 'nested',
                    workspace = 'school',
                },
            },
            ['core.keybinds'] = {
                config = {
                    neorg_leader = vim.g.neorg_leader,
                    hook = default_neorg_binds,
                },
            },
            ['core.qol.toc'] = {
                config = {
                    close_after_use = true,
                },
            },
            ['core.ui.calendar'] = {},
        },
    },
}
