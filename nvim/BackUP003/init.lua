
--Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins setup
require("lazy").setup({
  -- Plugin manager manages itself
  "folke/lazy.nvim",

  -- LSP and Mason for language servers
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",

  -- Autocomplete
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",

  -- Treesitter for syntax highlighting
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- File explorer with icons
  "nvim-tree/nvim-tree.lua",
  "nvim-tree/nvim-web-devicons",

  -- Telescope fuzzy finder and dependency
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Status line
  "nvim-lualine/lualine.nvim",

  -- Git integration
  "tpope/vim-fugitive",
  "lewis6991/gitsigns.nvim",

  -- Theme
  "morhetz/gruvbox",
})

-- Basic options
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.clipboard = "unnamedplus"
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4

vim.g.mapleader = " "  -- Leader key

-- Colorscheme
vim.cmd("colorscheme gruvbox")

-- Treesitter setup
require("nvim-treesitter.configs").setup({
  ensure_installed = { "python", "lua", "json", "bash", "sql" },
  highlight = { enable = true },
  indent = { enable = true },
})

-- Mason setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pyright" },
})

-- LSP config for pyright
local lspconfig = require("lspconfig")
lspconfig.pyright.setup({})

-- Autocomplete setup
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
    { name = "luasnip" },
  }),
})

-- Lualine setup
require("lualine").setup()

-- Nvim-tree setup
require("nvim-tree").setup()
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Telescope keymaps
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})

-- Gitsigns setup
require("gitsigns").setup()

-- Format on save for python using black
vim.cmd([[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePre *.py silent! execute '!black %'
  augroup END
]])

-- LSP keybindings
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

