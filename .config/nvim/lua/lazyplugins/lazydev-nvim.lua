return {
    "lazydev.nvim",
    ft = "lua",
    opt = true,
    after = function()
        require('lazydev').setup({
            enabled = true,
            runtime = vim.env.VIMRUNTIME --[[@as string]],
            library = {
                {
                    -- rocks-git puts luvit-meta git repo at stdpath('data')
                    -- instead of inside the vim.g.rocks_nvim.rocks_path
                    -- so the '..' is a cheap way to navigate between them
                    path = "${3rd}/../site/pack/rocks/start/luvit-meta",
                    words = { "vim%.uv" },
                },
            },
            integrations = {
                lspconfig = true,
                cmp = false,
                coq = false,
            },
            debug = false,
        })
    end,
}
