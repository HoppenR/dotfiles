local Oil = require('oil')
local Fns = require('functions')

-- Bookmarks
---@type table<string, string>
local oil_bookmarks = {
    ['/'] = '/',
    ['D'] = '~/Documents',
    ['P'] = '~/projects/personal',
    ['b'] = '~/.local/bin',
    ['c'] = '~/.config',
    ['h'] = '~',
    ['l'] = '~/Documents/LiU',
    ['n'] = '~/.config/nvim',
    ['p'] = '~/.config/nvim/lua/plugins',
}

-- Ranger-like 'g' keybind for selecting a bookmarked location via a single key
local function bookmark_prompt()
    ---@type string[]
    local prompt_lines = { 'key' .. '\t\t' .. 'location' }
    for key, path in pairs(oil_bookmarks) do
        table.insert(prompt_lines, key .. '\t\t' .. path)
    end
    ---@type string
    local selected_key = Fns.ranger_prompt(prompt_lines)
    ---@type string
    local target_path = oil_bookmarks[selected_key]
    if target_path then
        Oil.open(target_path)
    end
end

-- Global keybinds
vim.keymap.set('n', '<M-e>', Oil.open)

-- Local keybinds
---@return table<string, function|string>
local function default_oil_binds()
    return {
        ['<C-b>'] = {
            desc = 'Open the bookmark prompt',
            callback = bookmark_prompt,
        },
    }
end

Oil.setup({
    default_file_explorer = true,
    columns = {
        'icon',
        'permissions',
        'size',
        'mtime',
    },
    keymaps = default_oil_binds(),
})
