-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup
require("lazy").setup({
  -- Plugin manager manages itself
  "folke/lazy.nvim",

  -- LSP and Mason
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

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- File explorer
  "nvim-tree/nvim-tree.lua",
  "nvim-tree/nvim-web-devicons",

  -- Fuzzy finder
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Status line
  "nvim-lualine/lualine.nvim",

  -- Git
  "tpope/vim-fugitive",
  "lewis6991/gitsigns.nvim",

  -- Theme
  { "ellisonleao/gruvbox.nvim", priority = 1000 },

  -- JSON, Django, Templates
  "elzr/vim-json",
  "mustache/vim-mustache-handlebars",
  "tweekmonster/django-plus.vim",
  "jmcantrell/vim-virtualenv",
  "tpope/vim-projectionist",
  
  -- GitHub integration
  {
    "ldelossa/gh.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gh").setup()
      vim.keymap.set("n", "<leader>gh", ":GHViewer<CR>", { noremap = true, silent = true })
    end,
  },
  
  -- Lean support
  {
    "Julian/lean.nvim",
    event = { "BufReadPre *.lean", "BufNewFile *.lean" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("lean").setup{}
    end,
  },
})

-- Basic options
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.clipboard = "unnamedplus"
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.smartindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 300
vim.o.timeoutlen = 300

vim.g.mapleader = " "

-- Theme
vim.cmd("colorscheme gruvbox")

-- Treesitter
require("nvim-treesitter.configs").setup({
  ensure_installed = { 
    "python", "lua", "json", "html", "bash", "sql", 
    "javascript", "typescript", "markdown", "yaml", "lean", "csv", "toml"
  },
  sync_install = false,
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
})

-- Mason
require("mason").setup({
  ui = {
    border = "rounded"
  }
})

require("mason-lspconfig").setup({
  ensure_installed = { "pyright", "jsonls", "html", "bashls", "lua_ls" },
  automatic_installation = true,
})

-- LSP setup
local lspconfig = require("lspconfig")

-- Python
lspconfig.pyright.setup({
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        extraPaths = { 
          "/home/devuser/.local/lib/python3.10/site-packages",
          "/home/devuser/anaconda3/lib/python3.10/site-packages"
        },
        stubPath = "/home/devuser/.local/lib/python3.10/site-packages",
        -- ML/AI specific settings
        autoImportCompletions = true,
        indexing = true,
        diagnosticSeverityOverrides = {
          reportUnusedImport = "information",
          reportUnusedVariable = "information"
        }
      }
    }
  }
})

-- JSON
lspconfig.jsonls.setup({})

-- HTML
lspconfig.html.setup({})

-- Bash
lspconfig.bashls.setup({})

-- Lua
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }
      }
    }
  }
})

-- Autocomplete
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),
})

-- Lualine
require("lualine").setup({
  options = {
    theme = "gruvbox",
  }
})

-- Nvim-tree
require("nvim-tree").setup({
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- Gitsigns
require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
})

-- Format on save
vim.cmd([[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePre *.py silent! execute '!black --quiet %'
    autocmd BufWritePre *.html silent! execute '!djlint --reformat --quiet %'
    autocmd BufWritePre *.json silent! execute '%!jq .'
    autocmd BufWritePre *.ipynb silent! execute '!jupyter nbconvert --to notebook --inplace %'
  augroup END
]])

-- LSP Keybindings
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostics" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- General keybindings
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>x", ":x<CR>", { desc = "Save and quit" })

-- Virtualenv auto activation
vim.g.virtualenv_auto_activate = 1

-- Projectionist for Django structure
vim.g.projectionist_heuristics = {
  ["*.py"] = {
    ["models.py"] = {
      type = "model",
      alternate = "tests/test_models.py"
    },
    ["views.py"] = {
      type = "view",
      alternate = "tests/test_views.py"
    },
    ["urls.py"] = {
      type = "url",
      alternate = "tests/test_urls.py"
    }
  }
}

-- Error handling and diagnostics
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})