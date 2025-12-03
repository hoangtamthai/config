return {
    {
        "goolord/alpha-nvim", -- Start page
        -- dependencies = { 'echasnovski/mini.icons' },
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local startify = require("alpha.themes.startify")
            -- available: devicons, mini, default is mini
            -- if provider not loaded and enabled is true, it will try to use another provider
            startify.file_icons.provider = "devicons"
            require("alpha").setup(startify.config)
        end
    },
    {
        'preservim/nerdtree',                             -- File browser
        dependencies = { 'Xuyuanp/nerdtree-git-plugin' }, -- Git status
        cmd = 'NERDTreeToggle',
        keys = {
            { '<leader>e', ':NERDTreeToggle<CR>', desc = 'Toggle NERDTree' }
        },
        init = function()
            -- Global variables (g:) that need to be set before the plugin loads
            -- These are typically settings that affect NERDTree's core behavior
            vim.g.NERDTreeDirArrowExpandable = '▸'
            vim.g.NERDTreeDirArrowCollapsible = '▾'
            vim.g.NERDTreeGitStatusIndicatorMapCustom = {
                Modified = 'M',
                Staged = 'S',
                Untracked = 'U',
                Renamed = '➜',
                Unmerged = '═',
                Deleted = 'D',
                Dirty = 'd',
                Ignored = 'I',
                Clean = '✔︎',
                Unknown = '?',
            }
            vim.g.nerdtree_sync_cursorline = 1
        end,
        config = function()
            -- Autocommand group to ensure we can clear previous auto-commands
            local nerdtree_quit_augroup = vim.api.nvim_create_augroup("NERDTreeQuit", { clear = true })

            -- We use BufEnter, which triggers whenever a buffer is entered.
            -- This handles the case where the last file buffer is closed, and NERDTree becomes active.
            vim.api.nvim_create_autocmd("BufEnter", {
                group = nerdtree_quit_augroup,
                callback = function()
                    -- Check 1: Is there only one tab page remaining?
                    if vim.fn.tabpagenr('$') == 1 then
                        -- Check 2: Is there only one window remaining in that tab?
                        if vim.fn.winnr('$') == 1 then
                            -- Check 3 (The Fix): Does the remaining buffer have the filetype 'nerdtree'?
                            -- vim.bo.filetype is much more reliable than checking specific buffer variables.
                            if vim.bo.filetype == 'nerdtree' then
                                vim.cmd('quit')
                            end
                        end
                    end
                end,
            })
        end
    },
    {
        'nvim-telescope/telescope.nvim', -- File search
        dependencies = { 'nvim-lua/plenary.nvim' },
        cmd = "Telescope"
    },
    {
        'voldikss/vim-floaterm', -- Terminal
        lazy = true,
        opts = {
            -- Floaterm configuration options (corresponds to g:floaterm_ variables)
            position = 'topright',
            width = 0.6,
            height = 0.7,
            title = 'Terminal $1/$2',
            wintype = 'float',
            rootmarkers = { '.pro' },

            shell = vim.fn.has('win32') == 1 and 'pwsh -nologo' or nil -- Set to nil if not win32
        },

        -- Setting highlight groups
        config = function()
            -- Use vim.api.nvim_set_hl to set highlight groups
            vim.api.nvim_set_hl(0, 'Floaterm', {
                bg = '#1a1117'
            })
            vim.api.nvim_set_hl(0, 'FloatermBorder', {
                fg = 'Pink'
            })

            -- Autocommands
            -- The User FloatermOpen autocommand you had was empty,
            -- so it's not strictly necessary to include if it wasn't doing anything.
            -- If you want to add actions, you can define an autocommand here:
            -- vim.api.nvim_create_autocmd("User", {
                --   pattern = "FloatermOpen",
                --   callback = function()
                    --     -- Actions to perform after FloatermOpen
                    --     print("Floaterm opened!")
                    --   end
                    -- })

                    -- Keybindings (using vim.keymap.set)
                    -- Normal and Terminal mode mappings

                    -- Open a new terminal
                    vim.keymap.set({ 'n', 't' }, '<C-t>', ':FloatermNew<CR>', {
                        silent = true,
                        desc = 'Floaterm: New'
                    })

                    -- Kill current terminal (note: FloatermPrev might not be needed or could be separate)
                    -- I've kept the original behavior for now.
                    vim.keymap.set({ 'n', 't' }, '<leader>tk', ':FloatermKill<CR>:FloatermPrev<CR>', {
                        silent = true,
                        desc = 'Floaterm: Kill'
                    })

                    -- Navigation next and previous terminal
                    -- Your <C-S>j mapping seems a bit unusual for 'Next'.
                    -- I've included mappings for <C-S>j, <leader>tn, and <leader>tp as in your original config.
                    vim.keymap.set('n', '<C-S>j', ':FloatermNext<CR>', {
                        silent = true,
                        desc = 'Floaterm: Next (C-S-j)'
                    })
                    vim.keymap.set('t', '<leader>tn', '<C-\\><C-n>:FloatermNext<CR>', {
                        silent = true,
                        desc = 'Floaterm: Next (t)'
                    })
                    vim.keymap.set({ 'n', 't' }, '<leader>tp', ':FloatermPrev<CR>', {
                        silent = true,
                        desc = 'Floaterm: Previous'
                    })

                    -- Toggle terminal
                    vim.keymap.set({ 'n', 't' }, '<C-j>', ':FloatermToggle<CR>', {
                        silent = true,
                        desc = 'Floaterm: Toggle'
                    })

                    -- Focus terminal (Note: Your keymap is switching window left, not directly focusing Floaterm)
                    -- If you want to truly focus Floaterm, the command might be different or depend on how many windows are open.
                    -- I've kept the original behavior for now.
                    vim.keymap.set('n', '<leader>tf', '<C-\\><C-n><C-W><Left>', {
                        silent = true,
                        desc = 'Floaterm: Focus (Shift Left)'
                    })
                    vim.keymap.set('t', '<leader>tf', '<C-\\><C-n><C-W><Left>', {
                        silent = true,
                        desc = 'Floaterm: Focus (Shift Left)'
                    })

                    -- Hotkey to run other console apps (Git)
                    vim.keymap.set('n', '<leader>gl',
                    ":FloatermNew! --position=bottomright --height=0.95 --width=0.7 --title='GitLog' git lg<CR>", {
                        silent = true,
                        desc = 'Floaterm: Git Log'
                    })
                end
            },
            -- Useful shortcut
            {
                'tpope/vim-commentary', -- Comment code
                cmd = 'Commentary',
                opts = {
                    NERDCreateDefaultMappings = 1,

                    -- Add spaces after comment delimiters by default
                    NERDSpaceDelims = 1,

                    -- Use compact syntax for prettified multi-line comments
                    NERDCompactSexyComs = 1,

                    -- Align line-wise comment delimiters flush left instead of following code indentation
                    NERDDefaultAlign = 'left',

                    -- Set a language to use its alternate delimiters by default
                    NERDAltDelims_java = 1,

                    -- Add your own custom formats or override the defaults
                    -- NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } },

                    -- Allow commenting and inverting empty lines (useful when commenting a region)
                    NERDCommentEmptyLines = 1,

                    -- Enable trimming of trailing whitespace when uncommenting
                    NERDTrimTrailingWhitespace = 1,

                    -- Enable NERDCommenterToggle to check all selected lines is commented or not
                    NERDToggleCheckAllLines = 1
                },
            }
        }
