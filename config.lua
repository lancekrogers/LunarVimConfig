OBSIDIAN_PATH = os.getenv("OBSIDIAN_PATH")
-- vim options
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true
vim.opt.list = true
vim.opt.timeoutlen = 500
vim.opt.listchars = "tab:>-,trail:."
vim.keymap.set('n', '<F5>', vim.cmd.UndotreeToggle)
vim.g.winresizer_start_key = '<C-w>'
vim.opt.spelllang = 'en_us'

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { "*.py", "*.vy" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.colorcolumn = "80"
    vim.opt_local.textwidth = 79
  end
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { "*.ts", "*.js", "*.html", "*.css", "*.jsx", "*.sql", "*.sol", "*.lua" },
  callback = function()
    vim.opt_local.colorcolumn = "100"
    vim.opt_local.textwidth = 99
  end
})

-- Toggle spellcheck
vim.keymap.set("n", "<S-s>", function()
  vim.o.spell = not (vim.opt_local.spell:get())
  print("spell: " .. tostring(vim.o.spell))
end)

-- general
lvim.log.level = "info"
lvim.format_on_save = {
  enabled = true,
  pattern = "*.lua",
  timeout = 1000,
}

-- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "\\"
-- add your own keymapping
--
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["//"] = ":Ag<SPACE>"
lvim.keys.normal_mode["<C-e>"] = false
lvim.keys.normal_mode["<C-y>"] = false

-- lvim.keys.normal_mode["///"] = ":AgJS<SPACE>"
--...
-- lvim.builtin.nvimtree.active = false -- NOTE: using nerdtree
lvim.builtin.nvimtree.setup.view.relativenumber = true
lvim.builtin.nvimtree.setup.reload_on_bufenter = false
lvim.builtin.indentlines.options = { use_treesitter = false, filetype_exclude = { 'help', '.mod' } }


lvim.builtin.terminal.open_mapping = "<c-t>"

-- Buffer management
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<S-d>"] = ":BufferLinePickClose<CR>"
lvim.keys.normal_mode["<S-p>"] = ":BufferLinePick<CR>"

lvim.keys.normal_mode["<F1>"] = "<Plug>RestNvim"
lvim.keys.normal_mode["<F2>"] = "<Plug>RestNvimPreview"
lvim.keys.normal_mode["<F3>"] = "<Plug>RestNvimLast"


lvim.keys.normal_mode["tt"] = ":bnext<CR>"
lvim.keys.normal_mode["tT"] = ":bprev<CR>"

-- -- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["jf"] = { ":%!jq .<cr>", "Format JSON" }

-- -- Change theme settings
-- lvim.colorscheme = "lunar"
-- Use yow in normal mode to wrap text in markdown and other text files

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = false

-- -- Additional Plugins <https://www.lunarvim.org/docs/plugins#user-plugins>
lvim.plugins = {
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit"
    },
    ft = { "fugitive" }
  },
  {
    "pwntester/octo.nvim",
    config = function()
      require("octo").setup()
    end,
  },
  {
    "jacqueswww/vim-vyper"
  },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require('go.format').goimport()
        end,
        group = format_sync_grp,
      })
      require("go").setup({
        -- goimport = 'gopls',
        max_line_len = 120,
      })
    end
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-go").setup()
    end,
  },
  {
    "pwntester/octo.nvim",
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      -- 'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require("octo").setup()
    end,
  },
  {
    'kelly-lin/telescope-ag',
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    'xolox/vim-notes',
    dependencies = {
      'xolox/vim-misc'
    },
    config = function()
      vim.g.notes_directories = { OBSIDIAN_PATH .. "VimNotes/" }
      vim.g.notes_suffix = ".md"
    end,
  },
  {
    "epwalsh/obsidian.nvim",
    config = function()
      require("obsidian").setup({
        dir = OBSIDIAN_PATH,
        notes_subdir = "Notes",
      })
    end,
  },
  {
    "lancekrogers/kanban.nvim",
    config = function()
      require("kanban").setup({
        markdown = {
          description_folder = "./tasks/", -- Path to save the file corresponding to the task.
          list_head = "## ",
        }
      })
    end,
  },
  {
    'simeji/winresizer'
  },
  {
    'karb94/neoscroll.nvim',
    event = "WinScrolled",
    config = function()
      require('neoscroll').setup({
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
          '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = true,          -- Hide cursor while scrolling
        stop_eof = true,             -- Stop at <EOF> when scrolling downwards
        use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
        respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = nil,       -- Default easing function
        pre_hook = nil,              -- Function to run before the scrolling animation starts
        post_hook = nil,             -- Function to run after the scrolling animation ends
      })
    end,
  },
  {
    "lancekrogers/vim-log-highlighting",
  },
  {
    'airblade/vim-gitgutter'
  },
  {
    'mbbill/undotree'
  },
  {
    'simeji/winresizer'
  },
  {
    "andrewferrier/wrapping.nvim",
    config = function()
      require("wrapping").setup()
    end
  },
  {
    "tiagovla/scope.nvim",
    config = function()
      require("scope").setup({
        restore_state = false, -- experimental
      })
    end
  },
  {
    "hudclark/grpc-nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("rest-nvim").setup()
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = "markdown",
    config = function()
      vim.g.mkdp_auto_start = 1
    end,
  },
  { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
  {
    "rmagatti/goto-preview",
    config = function()
      require('goto-preview').setup {
        width = 120,             -- Width of the floating window
        height = 25,             -- Height of the floating window
        default_mappings = true, -- Bind default mappings
        opacity = 0,             -- 0-100 opacity level of the floating window where 100 is fully transparent.
        dismiss_on_move = false,
      }
    end
  },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    config = function()
      require("venv-selector").setup {
        poetry_path = "~/Library/Caches/pypoetry",
        -- pipenv_path = "your_path_here",
        -- pyenv_path = "your_path_here",
        -- anaconda_path = "your_path_here",
      }
    end,
    event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
  },
}

lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "ag")
end

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { name = "black" },
  {
    name = "prettier",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespace
    -- options such as `--line-width 80` become either `{"--line-width", "80"}` or `{"--line-width=80"}`
    args = { "--print-width", "100" },
    ---@usage only start in these filetypes, by default it will attach to all filetypes it supports
    filetypes = { "typescript", "typescriptreact" },
  },
  { name = "goimports" },
  { name = "eslint" }
}
lvim.format_on_save.enabled = true
lvim.format_on_save.pattern = { "*.py", "*.lua", "*.js", "*.ts", "*.go" }

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  {
    name = "flake8",
    args = { "--ignore=E501,W503" }
  },

}

-- Debugging
--
vim.keymap.set('n', '<F9>', function() require('dap').continue() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
