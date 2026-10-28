local status, telescope = pcall(require, "telescope.builtin")
if (not status) then return end

vim.keymap.set('n', '<c-p>', function() telescope.find_files() end) -- open fzf
