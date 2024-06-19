return {
    "lazydev.nvim",
    ft = "lua",
    opt = true,
    after = function()
        require('lazydev').setup({
            library = {
                {
                    path = "site/pack/rocks/start/luvit-meta/library",
                    words = { "vim%.uv" },
                },
            },
        })
    end,
}
