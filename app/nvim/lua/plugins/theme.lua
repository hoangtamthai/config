return {
    'akinsho/bufferline.nvim',    -- Make buffer nice looking
    {
        'ryanoasis/vim-devicons', -- Icon
        lazy = true
    },

    -- Status bar
    'nvim-lualine/lualine.nvim',

    -- Color and syntax highlight
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate"
    },
    {
        'norcalli/nvim-colorizer.lua', -- Make color string show it color
        config = function()
            require('colorizer').setup {
                '*',
            }
        end
    },
}
