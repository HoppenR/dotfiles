-- List of LSP servers to enable, and their configs
local lsp_servers_list = {
    ['clangd'] = {},
    ['gopls'] = {
        gopls = {
            analyses = {
                shadow = true,
                unusedparams = true,
            },
            staticcheck = true,
            usePlaceholders = true,
        },
    },
    ['lua_ls'] = {
        Lua = {
            completion = {
                callSnippet = 'Replace',
            },
            diagnostics = {
                globals = { "vim" },
            },
            hint = {
                enable = true,
            },
            runtime = {
                version = 'LuaJIT',
            },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                    [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
                },
            },
        },
    },
    ['pylsp'] = {
        pylsp = {
            plugins = {
                autopep8 = {
                    enabled = true,
                },
                jedi_completion = {
                    fuzzy = true,
                    include_params = true,
                },
            },
        },
    },
    ['rust_analyzer'] = {
        ['rust-analyzer'] = {
            checkOnSave = true,
            diagnostics = {
                experimental = {
                    enable = false,
                },
            },
        },
    },
    ['ocamllsp'] = {},
}

-- Local keybinds
local function default_lsp_binds(_, bufnr)
    vim.keymap.set({ 'i', 's' }, '<C-s>', vim.lsp.buf.signature_help, { buffer = bufnr })
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, { buffer = bufnr })
    vim.keymap.set('n', '<F3>', vim.lsp.buf.format, { buffer = bufnr })
    vim.keymap.set('n', '<F4>', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { buffer = bufnr })
    vim.keymap.set('n', '<M-d>', vim.lsp.buf.code_action, { buffer = bufnr })
    vim.keymap.set('n', '<M-n>', vim.diagnostic.goto_next, { buffer = bufnr })
    vim.keymap.set('n', '<M-p>', vim.diagnostic.goto_prev, { buffer = bufnr })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
end

-- Return Lazy config
return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp', -- for default LSP capabilities
    },
    config = function()
        local lspconfig = require('lspconfig')
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local lsp_info_win = require('lspconfig.ui.windows')


        -- :LspInfo
        lsp_info_win.default_options.border = 'rounded'
        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
            vim.lsp.handlers.hover,
            { border = 'rounded' }
        )
        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
            vim.lsp.handlers.signature_help,
            { border = 'rounded' }
        )
        vim.diagnostic.config({
            float = { border = 'rounded' },
            signs = false,
            underline = true,
            update_in_insert = false,
        })

        for server_name, server_conf in pairs(lsp_servers_list) do
            lspconfig[server_name].setup({
                capabilities = capabilities,
                inlay_hints = { enabled = true },
                on_attach = default_lsp_binds,
                on_init = function(client)
                    client.config.settings = vim.tbl_deep_extend(
                        'force',
                        client.config.settings,
                        server_conf
                    )
                end
            })
        end

        local LspSettings = vim.api.nvim_create_augroup(
            'LspSettings',
            { clear = true }
        )
        vim.api.nvim_create_autocmd('LspAttach', {
            group = LspSettings,
            callback = function(event)
                vim.api.nvim_create_autocmd(
                    'CursorHold',
                    {
                        buffer = event.buf,
                        callback = vim.lsp.buf.document_highlight,
                    }
                )
                vim.api.nvim_create_autocmd(
                    'CursorMoved',
                    {
                        buffer = event.buf,
                        callback = vim.lsp.buf.clear_references,
                    }
                )
            end
        })
    end,
}
