--
-- ~/.config/nvim/lua/plugins/init.lua
--

-- IDEA: Github copilot?
-- IDEA: lewis6991/gitsigns.nvim

return {
    --[[ Plugin Manager ]]
    -- 'folke/lazy.nvim' --> ./init.lua
    -- 'vhyrro/luarocks.nvim' --> ./luarocks-nvim.lua
    --                        --> (Manages dependencies for neorg setup)

    --[[ File Manager ]]
    -- 'stevearc/oil.nvim' --> ./oil-nvim.lua

    --[[ Language Server Protocol ]]
    -- 'neovim/nvim-lspconfig' --> ./nvim-lspconfig.lua
    -- 'j-hui/fidget.nvim' --> ./fidget-nvim.lua
    -- 'folke/lazydev.nvim' --> ./lazydev-nvim.lua

    --[[ Notifications ]]
    -- 'rcarriga/nvim-notify' --> ./nvim-notify.lua

    --[[ Completion ]]
    -- 'hrsh7th/nvim-cmp' --> ./nvim-cmp.lua

    --[[ Telescope ]]
    -- 'nvim-telescope/telescope' --> ./telescope.lua

    --[[ Treesitter ]]
    -- 'nvim-treesitter/nvim-treesitter' --> ./nvim-treesitter.lua
    --                                   --> (Also opt for nvim-notify)

    --[[ Neorg ]]
    -- 'nvim-neorg/neorg' --> ./neorg.lua

    --[[ Undotree ]]
    -- 'jiaoshijie/undotree' --> ./undotree.lua

    --[[ Dependencies (Extra) ]]
    --  package                         location
    -- 'nvim-lua/plenary.nvim'          ./telescope.lua
    --                                  ./undotree.lua
    -- 'hrsh7th/cmp-nvim-lsp'           ./nvim-cmp.lua
    --                                  ./nvim-lspconfig.lua
    -- 'hrsh7th/cmp-buffer'             ./nvim-cmp.lua
    -- 'hrsh7th/cmp-cmdline'            ./nvim-cmp.lua
    -- 'hrsh7th/cmp-path'               ./nvim-cmp.lua
    -- 'nvim-tree/nvim-web-devicons'    ./oil-nvim.lua
    --                                  ./telescope.lua
    -- 'Bilal2453/luvit-meta'           ./lazydev-nvim.lua

    --[[ Local plugins ]]
    {
        dir = '~/.local/share/nvim/lazy/storm-mode.nvim',
        opts = {
            compiler = vim.fn.expand('~/projects/storm-lang/storm'),
            root = vim.fn.expand('~/projects/storm-lang/root/'),
        },
    },
}
