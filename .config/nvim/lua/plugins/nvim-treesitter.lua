require('nvim-treesitter').setup()

require('nvim-treesitter.configs').setup({
    modules = {},
    auto_install = false,
    ensure_installed = {},
    parser_install_dir = nil,
    -- 'norg' and 'norg-meta' is handled by .build in ./neorg.lua
    ignore_install = {
        'norg',
        'norg-meta',
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<M-v>',
            node_incremental = '<M-v>',
            -- scope_incremental = 'grc',
            node_decremental = '<M-S-v>',
        },
    },
    additional_vim_regex_highlighting = false,
    highlight = { enable = true },
    indent = { enable = true },
    sync_install = false,
})
