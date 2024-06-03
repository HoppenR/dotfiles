return {
    'vhyrro/luarocks.nvim',
    priority = 1000,
    opts = {
        luarocks_build_args = {
            "--with-lua-include=/usr/include",
        },
    },
}
