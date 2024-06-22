require('fidget').setup({
    integration = {
        ['nvim-tree'] = {
            enable = false,
        },
        ['xcodebuild-nvim'] = {
            enable = false,
        },
    },
    notification = {
        override_vim_notify = true,
        view = {
            stack_upwards = false,
        },
        window = {
            border = 'rounded',
        },
    },
})
