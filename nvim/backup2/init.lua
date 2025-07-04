-- PACKER SETUP
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  -- Packer manages itself
  use 'wbthomason/packer.nvim'

  -- LSP + Autocomplete
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  -- Treesitter for syntax highlighting
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- File explorer
  use 'nvim-tree/nvim-tree.lua'
  use 'nvim-tree/nvim-web-devicons' -- Optional icons

  -- Telescope for fuzzy finding
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }

  -- Statusline
  use 'nvim-lualine/lualine.nvim'

  -- Git integrations
  use 'tpope/vim-fugitive'
  use 'lewis6991/gitsigns.nvim'

  -- Formatter
  use 'psf/black'

  -- Theme
  use 'morhetz/gruvbox'
   
    
end)

-- GENERAL SETTINGS
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.clipboard = "unnamedplus"
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4

vim.cmd("colorscheme gruvbox")

-- TREESITTER
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "python", "lua", "json", "bash", "sql" },
  highlight = { enable = true },
  indent = { enable = true }
}

-- MASON (LSP Installer)
require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "pyright" }
}

-- LSP CONFIG
local lspconfig = require('lspconfig')
lspconfig.pyright.setup{}

lspconfig.omnisharp.setup {
      cmd = { os.getenv("HOME") .. "/.local/bin/omnisharp/OmniSharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
}

-- AUTOCOMPLETE
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require'luasnip'.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'luasnip' },
  })
})

-- LUALINE
require('lualine').setup()

-- NVIM-TREE
require("nvim-tree").setup()
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- TELESCOPE
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- GITSIGNS
require('gitsigns').setup()

-- FORMAT ON SAVE WITH BLACK
vim.cmd [[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePre *.py silent! execute '!black %'
  augroup END
]]

-- LSP KEYBINDINGS
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})

-- MISC
vim.g.mapleader = " "  -- Leader key
