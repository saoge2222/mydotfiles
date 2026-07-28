vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.autoindent = true
vim.opt.wrap = false
vim.opt.scrolloff = 20
vim.opt.sidescrolloff = 20
vim.opt.cursorline = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.showmode = false

vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    spec = {
        -- autopairs
        {
            "windwp/nvim-autopairs",
            opts = {},
        },
        -- gruvbox theme
        { 
            "ellisonleao/gruvbox.nvim", priority = 1000 , config = true,
            config = function()
                vim.cmd("colorscheme gruvbox")
            end
    	},
        -- tokyonight theme
        {
            'folke/tokyonight.nvim', lazy = false , priority = 1000,
            opts = { style = 'moon' },
        },
        -- catppuccin theme
        {
            "catppuccin/nvim", name = "catppuccin", priority = 1000
        },
        -- Oil 
        {
            'stevearc/oil.nvim', opts = {},
            dependencies = { "nvim-tree/nvim-web-devicons" }, 
            lazy = false,
            opts = {
                columns = {
                    "permissions","size","icon",
                },
                view_options = {
                    show_hidden = true
                },
            }
        },
        -- tree-sitter
        {
            'nvim-treesitter/nvim-treesitter',
            lazy = false, build = ':TSUpdate',
            opts = {
                ensure_installed = {'lua'},
                highlight = { enable = true },
            }
        },
        -- bufferline
        {
            'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons',
            keys = {
                { "<leader>bh", ":BufferLineCyclePrev<CR>", silent = true },
                { "<leader>bl", ":BufferLineCycleNext<CR>", silent = true },
                { "<leader>bd", ":bdelete<CR>", silent = true },
            },
            opts = {},
            lazy = false
        },
        -- telescope
        {
            'nvim-telescope/telescope.nvim', version = "*", dependencies = { 'nvim-lua/plenary.nvim', { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' } },
            config = function()
                local builtin = require('telescope.builtin')
                vim.keymap.set('n', '<leader>tf', builtin.find_files, { desc = 'Telescope find_files' })
                vim.keymap.set('n', '<leader>tg', builtin.live_grep,  { desc = 'Telescope live_grep' })
                vim.keymap.set('n', '<leader>tb', builtin.buffers,    { desc = 'Telescope buffers' })
                vim.keymap.set('n', '<leader>th', builtin.help_tags,  { desc = 'Telescope help_tags' })
            end
        },
        -- noice.nvim
        {
            "folke/noice.nvim",
            event = "VeryLazy",
            opts = {},
            dependencies = {
                "MunifTanjim/nui.nvim",
                "rcarriga/nvim-notify",
            },
        },
        -- lualine
        {
            'nvim-lualine/lualine.nvim', dependencies = 'nvim-tree/nvim-web-devicons',
            opts = {
                sections = {
                    lualine_a = {{'mode', fmt = function(str) return ' '..str:sub(1,3) end }},
                    lualine_b = {'filename', 'filesize', 'encoding'},
                    lualine_c = {},
                    lualine_x = {'location', 'progress'},
                    lualine_y = {},
                    lualine_z = {}
            	},
            },
	}
    }
})
