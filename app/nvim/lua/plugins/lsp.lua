return {
    -- Code intellisense, Language server protocol (LSP)
    {
        'williamboman/mason.nvim', -- LSP, DAP, Linter Manager
        lazy = true
    },
    {
        'williamboman/mason-lspconfig.nvim', -- Work with nvim-lspconfig
        lazy = true
    },
    {
        'neovim/nvim-lspconfig', -- builtin lsp nvim
        lazy = true
    },
    {
        'jiangmiao/auto-pairs', -- Parenthesis auto
        lazy = true
    },
    {
        'alvan/vim-closetag', -- Auto close tag
        lazy = true
    },
    {
        'onsails/lspkind.nvim', -- styling the suggestion like VSCode
        lazy = true
    },
    {
        'hrsh7th/nvim-cmp', -- Suggestion
        event = "InsertEnter",
        dependencies = {
            'hrsh7th/cmp-nvim-lsp', -- Suggestion source lsp
            'hrsh7th/cmp-buffer',   -- Suggestion source buffer
            'hrsh7th/cmp-path',     -- Suggestion source path
            'hrsh7th/cmp-cmdline',  -- Suggestion source cmdline
        }
    },
}
