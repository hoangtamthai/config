local function map(mode, shortcut, command)
    vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

local function nmap(shortcut, command)
    map('n', shortcut, command)
end

local function imap(shortcut, command)
    map('i', shortcut, command)
end

local function vmap(shortcut, command)
    map('v', shortcut, command)
end
--Remap keys:
-- normal mode:
nmap('<Space>', '<Nop>')                   --make leader key no weird
nmap('Y', 'y$')                            --Y behave like D
nmap('j', 'gj')                            --moving through wrap
nmap('k', 'gk')
nmap('<tab>', ':bn<CR>')                   --next buffer
nmap('<S-tab>', ':bp<CR>')                 --previous buffer
nmap('<C-_>', ':Commentary<CR>')           --toggle comment
nmap('<CR>', ':noh<CR><CR>')               --enter will hide highlight
nmap('<C-s>', ':w!<CR>')                   --save buffer
nmap('<C-p>', ':Telescope find_files<CR>') --save buffer

-- insert mode:
--  undo more fine-grained
imap(',', ',<C-g>u')
imap('.', '.<C-g>u')
imap('?', '?<C-g>u')
imap('jk', '<Esc>') --to escape

-- visual mode
--  go through wr
vmap('j', 'gj')
vmap('k', 'gk')
vmap('<C-_>', ':Commentary<CR>') --toggle comment
