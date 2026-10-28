local status, mason = pcall(require, 'mason')
if (not status) then return end
local status2, mason_lspconfig = pcall(require, 'mason-lspconfig')
if (not status2) then return end

mason.setup({
    PATH = "prepend",
})
mason_lspconfig.setup({})
