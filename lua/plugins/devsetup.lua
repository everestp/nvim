-- ~/.config/nvim/lua/plugins/devsetup.lua
return {
  -- Gruvbox theme (Dark Mode: hard, transparent)
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup({ contrast = "hard", transparent_mode = true })
      vim.cmd("colorscheme gruvbox")
    end,
  },

  -- Telescope fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup{
        defaults = {
          prompt_prefix = "🔍 ",
          selection_caret = "➤ ",
          path_display = { "smart" },
        },
      }
    end,
  },

  -- Treesitter for syntax highlighting & color-aware
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "rust", "go", "typescript", "javascript", "python", "yaml", "json", "html", "css", "bash" },
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        indent = { enable = true },
      })
    end,
  },

  -- Mason + LSP
  { "williamboman/mason.nvim", config = true },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "rust_analyzer", "gopls", "tsserver", "pyright", "yamlls" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lsp = require("lspconfig")
      local servers = { "rust_analyzer", "gopls", "tsserver", "pyright", "yamlls", "lua_ls" }
      for _, s in ipairs(servers) do
        lsp[s].setup({})
      end
      lsp.lua_ls.setup({ settings = { Lua = { diagnostics = { globals = { "vim" } } } } })
    end,
  },

  -- Autocompletion (Cmp + LuaSnip)
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = {
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
          { name = "luasnip" },
        },
      })
    end,
  },

  -- Statusline (lualine) – colorful, Gruvbox-friendly
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function git_status_summary()
        local gitsigns = vim.b.gitsigns_status_dict
        if not gitsigns then return "" end
        local branch = gitsigns.head or ""
        local added   = gitsigns.added   and ("➕"..gitsigns.added) or ""
        local changed = gitsigns.changed and ("✍️"..gitsigns.changed) or ""
        local removed = gitsigns.removed and ("➖"..gitsigns.removed) or ""
        local parts = {}
        if branch ~= "" then table.insert(parts, " "..branch) end
        if added ~= "" then table.insert(parts, added) end
        if changed ~= "" then table.insert(parts, changed) end
        if removed ~= "" then table.insert(parts, removed) end
        return #parts > 0 and table.concat(parts, " ") or ""
      end

      require("lualine").setup({
        options = {
          theme = "gruvbox",
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          globalstatus = true,
          winbar = { lualine_c = { { "filename", path = 1 } } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { git_status_summary, "diff" },
          lualine_c = { "filename" },
          lualine_x = { "diagnostics", "encoding", "fileformat", "filetype" },
          lualine_y = {},
          lualine_z = { "progress", "location", { function() return os.date("%H:%M") end } },
        },
      })
    end,
  },

  -- Comment toggler
  { "numToStr/Comment.nvim", config = true },

  -- Toggle terminal
  { "akinsho/toggleterm.nvim", version = "*", config = function() require("toggleterm").setup{} end },

  -- Undo history
  { "mbbill/undotree" },

  -- Git signs
  { "lewis6991/gitsigns.nvim", config = true },

  -- Bufferline tabs (colorful)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          separator_style = "slant",
          show_buffer_close_icons = false,
          show_close_icon = false,
          indicator = { style = "icon", icon = "▎" },
        },
      })
    end,
  },

  -- Dashboard (Alpha)
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "██╗   ██╗███████╗██╗   ██╗██████╗ ",
        "██║   ██║██╔════╝██║   ██║██╔══██╗",
        "██║   ██║█████╗  ██║   ██║██████╔╝",
        "██║   ██║██╔══╝  ██║   ██║██╔═══╝ ",
        "╚██████╔╝███████╗╚██████╔╝██║     ",
        " ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝     ",
      }
      dashboard.section.buttons.val = {
        dashboard.button("e", " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", " Find file", ":Telescope find_files<CR>"),
        dashboard.button("r", " Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("q", " Quit", ":qa<CR>"),
      }
      alpha.setup(dashboard.config)
    end,
  },

  -- Which-key (leader hints)
  { "folke/which-key.nvim", config = function() require("which-key").setup{} end },
}
