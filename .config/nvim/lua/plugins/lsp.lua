local Lspconfig = require('lspconfig')

-- List of LSP servers to enable, and their configs
local lsp_servers_list = {
    ['clangd'] = {},

    -- ['dartls'] = {},
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
    vim.keymap.set('i', '<C-Space>', vim.lsp.completion.get, { buffer = event.buf })

    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, { buffer = event.buf })
    vim.keymap.set('n', '<F3>', vim.lsp.buf.format, { buffer = event.buf })
    vim.keymap.set('n', '<F4>', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
    end, { buffer = event.buf })
    vim.keymap.set('n', '<M-d>', vim.lsp.buf.code_action, { buffer = event.buf })
    vim.keymap.set('n', '<M-n>', function() vim.diagnostic.jump({ count = 1, float = true }) end, { buffer = event.buf })
    vim.keymap.set('n', '<M-p>', function() vim.diagnostic.jump({ count = -1, float = true }) end, { buffer = event.buf })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = event.buf })
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, { buffer = event.buf })

    vim.keymap.set({ 'i', 's' }, '<C-h>', function() vim.snippet.jump(-1) end, { buffer = event.buf })
    vim.keymap.set({ 'i', 's' }, '<C-l>', function() vim.snippet.jump(1) end, { buffer = event.buf })
end

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        if client:supports_method('textDocument/completion', ev.buf) then
            ---@type [string]
            local all = {}
            for code = 32, 126 do
                table.insert(all, string.char(code))
            end

            ---@type [string]
            local excludes = { " ", "(", ")", ";", "<", ">", "[", "]", "{", "}" }

            ---@type [string]
            local chars = vim.tbl_filter(
                function(ch)
                    return not vim.tbl_contains(excludes, ch)
                end,
                all
            )

            client.server_capabilities.completionProvider.triggerCharacters = chars
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
    end,
})

local LspKeybinds = vim.api.nvim_create_augroup('LspKeybinds', {
    clear = true
})
vim.api.nvim_create_autocmd('LspAttach', {
    group = LspKeybinds,
    callback = default_lsp_binds,
})

for server_name, server_conf in pairs(lsp_servers_list) do
    Lspconfig[server_name].setup({
        inlay_hints = { enabled = true },
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
