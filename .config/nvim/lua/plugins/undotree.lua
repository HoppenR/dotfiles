return {
    "jiaoshijie/undotree",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = true,
    lazy = true,
    keys = {
        { "<leader>u", function() require('undotree').toggle() end },
    },
    opts = {
        float_diff = true,
        ignore_filetype = {
            'TelescopePrompt',
            'undotree',
            'undotreeDiff',
            'minifiles',
        },
        position = "left",
        window = {
            winblend = vim.o.winblend,
        },
        keymaps = {
            ['<C-p>'] = "enter_diffbuf",
        },
    },
}
