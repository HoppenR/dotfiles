--
-- ~/.config/nvim/ftplugin/norg.lua
--

-- Don't autowrap text
vim.opt_local.formatoptions:remove('t')
-- Don't autowrap "comments"
vim.opt_local.formatoptions:remove('c')
