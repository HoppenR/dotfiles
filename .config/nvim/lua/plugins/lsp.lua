local Blinkcmp = require('blink.cmp')
local LspInfoWin = require('lspconfig.ui.windows')
local Lspconfig = require('lspconfig')

-- List of LSP servers to enable, and their configs
local lsp_servers_list = {
    ['clangd'] = {},
    ['dartls'] = {},
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
    ['hls'] = {},
    ['lua_ls'] = {
        Lua = {
            completion = {
                callSnippet = 'Replace',
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
}

-- Local keybinds
local function default_lsp_binds(event)
    vim.keymap.set({ 'i', 's' }, '<C-s>', vim.lsp.buf.signature_help, { buffer = event.buf })
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, { buffer = event.buf })
    vim.keymap.set('n', '<F3>', vim.lsp.buf.format, { buffer = event.buf })
    vim.keymap.set('n', '<F4>', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
    end, { buffer = event.buf })
    vim.keymap.set('n', '<M-d>', vim.lsp.buf.code_action, { buffer = event.buf })
    vim.keymap.set('n', '<M-n>', vim.diagnostic.goto_next, { buffer = event.buf })
    vim.keymap.set('n', '<M-p>', vim.diagnostic.goto_prev, { buffer = event.buf })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = event.buf })
end

local LspKeybinds = vim.api.nvim_create_augroup('LspKeybinds', {
    clear = true
})
vim.api.nvim_create_autocmd('LspAttach', {
    group = LspKeybinds,
    callback = default_lsp_binds,
})

-- :LspInfo
LspInfoWin.default_options.border = 'rounded'
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
vim.diagnostic.config({
    float = { border = 'rounded' },
    signs = false,
    underline = true,
    update_in_insert = false,
    virtual_text = true,
})

local capabilities = Blinkcmp.get_lsp_capabilities()
for server_name, server_conf in pairs(lsp_servers_list) do
    Lspconfig[server_name].setup({
        capabilities = capabilities,
        inlay_hints = { enabled = true },
        -- on_attach = default_lsp_binds,
        on_init = function(client)
            client.config.settings = vim.tbl_deep_extend(
                'force',
                client.config.settings,
                server_conf
            )
        end
    })
end

local LspSettings = vim.api.nvim_create_augroup('LspSettings', {
    clear = true
})
vim.api.nvim_create_autocmd('LspAttach', {
    group = LspSettings,
    callback = function(event)
        vim.api.nvim_create_autocmd('CursorHold', {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd('CursorMoved', {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
        })
    end
})
