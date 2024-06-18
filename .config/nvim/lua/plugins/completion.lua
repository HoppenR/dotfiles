local Cmp = require('cmp')

-- Scroll to next entry, inserting it, or fall back to opening completion
local function insert_next_or_complete()
    return function()
        if Cmp.visible() then
            Cmp.select_next_item({ behavior = Cmp.SelectBehavior.Insert })
        else
            Cmp.complete()
        end
    end
end

-- Scroll to prev entry, inserting it, or fall back to opening completion
local function insert_prev_or_complete()
    return function()
        if Cmp.visible() then
            Cmp.select_prev_item({ behavior = Cmp.SelectBehavior.Insert })
        else
            Cmp.complete()
        end
    end
end

-- Scroll to next entry, only selecting it, or use sensible fallback
-- local function select_next_or_fallback()
--     return function(fallback)
--         if Cmp.visible() then
--             Cmp.select_next_item({ behavior = Cmp.SelectBehavior.Select })
--         else
--             fallback()
--         end
--     end
-- end

-- Scroll to prev entry, only selecting it, or use sensible fallback
local function select_prev_or_fallback()
    return function(fallback)
        if Cmp.visible() then
            Cmp.select_prev_item({ behavior = Cmp.SelectBehavior.Select })
        else
            fallback()
        end
    end
end

-- Global keybinds
vim.keymap.set({ 'i', 's' }, '<C-h>', function() vim.snippet.jump(-1) end)
vim.keymap.set({ 'i', 's' }, '<C-l>', function() vim.snippet.jump(1) end)

-- Local keybinds
local default_cmp_keybinds = {
    ['<C-b>'] = Cmp.mapping(Cmp.mapping.scroll_docs(-4), { 'c', 'i' }),
    ['<C-e>'] = Cmp.mapping(Cmp.mapping.abort(), { 'c', 'i' }),
    ['<C-f>'] = Cmp.mapping(Cmp.mapping.scroll_docs(4), { 'c', 'i' }),
    ['<C-Space>'] = Cmp.mapping(Cmp.mapping.complete({}), { 'c', 'i' }),
    ['<C-n>'] = Cmp.mapping(insert_next_or_complete(), { 'c', 'i' }),
    ['<C-p>'] = Cmp.mapping(insert_prev_or_complete(), { 'c', 'i' }),
    ['<C-y>'] = Cmp.mapping(Cmp.mapping.confirm({ select = true }), { 'c', 'i' }),
    ['<Tab>'] = {
        c = insert_next_or_complete(),
        -- i = select_next_or_fallback(cmp),
    },
    ['<S-Tab>'] = {
        c = insert_prev_or_complete(),
        i = select_prev_or_fallback(),
    },
}

Cmp.setup({
    completion = {
        keyword_length = 3,
    },
    preselect = Cmp.PreselectMode.None,
    mapping = default_cmp_keybinds,
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
    sources = Cmp.config.sources(
        {
            { name = 'neorg' },
            { name = 'nvim_lsp' },
            { name = 'snp' },
            { name = 'path' },
        }, {
            -- Fallback sources
            { name = 'buffer', option = { keyword_pattern = [[\k\+]] } },
        }
    ),
    window = {
        completion = Cmp.config.window.bordered(),
        documentation = Cmp.config.window.bordered(),
    },
})

-- ':' -> Normal commands
-- '@' -> User defined commands, like vim.ui.input()
Cmp.setup.cmdline({ ':', '@' }, {
    mapping = default_cmp_keybinds,
    sources = Cmp.config.sources(
        {
            { name = 'cmdline' },
            { name = 'path' },
        }
    )
})

-- '/' | '?' -> Searching
Cmp.setup.cmdline({ '/', '?' }, {
    mapping = default_cmp_keybinds,
    completion = {
        -- Auto suggestions prevents scrolling up in search history
        -- with the <Up> and <Down> arrow keys
        autocomplete = false,
    },
    sources = {
        { name = 'buffer' }
    }
})
