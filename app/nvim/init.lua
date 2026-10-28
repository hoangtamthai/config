if vim.g.vscode then
    -- VSCode extension
else
    require('base')
    require('mapping')
    require('color') -- has custom highlight
    require('config.lazy')
end
