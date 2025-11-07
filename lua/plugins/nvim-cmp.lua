-- ================================================================================================
-- TITLE : nvim-cmp (Gruvbox Full Setup)
-- ABOUT : Transparent, full-featured completion & docs for Rust & other languages
-- ================================================================================================

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "onsails/lspkind.nvim",                  -- VS Code-like icons
        "saadparwaiz1/cmp_luasnip",             -- LuaSnip source
        {
            "L3MON4D3/LuaSnip",                 -- Snippet engine
            version = "v2.*",
            build = "make install_jsregexp",
        },
        "rafamadriz/friendly-snippets",         -- Prebuilt snippets
        "hrsh7th/cmp-nvim-lsp",                 -- LSP source
        "hrsh7th/cmp-buffer",                   -- Buffer words
        "hrsh7th/cmp-path",                     -- File paths
        "hrsh7th/cmp-nvim-lsp-signature-help", -- Function signatures
    },

    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")

        -- Load friendly snippets
        require("luasnip.loaders.from_vscode").lazy_load()

        -- CMP setup
        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },

            -- Window styling (transparent + rounded borders)
            window = {
                completion = cmp.config.window.bordered({
                    border = "rounded",
                    winhighlight = "NormalFloat:Pmenu,FloatBorder:FloatBorder,CursorLine:CursorLine",
                    scrollbar = false,
                }),
                documentation = cmp.config.window.bordered({
                    border = "rounded",
                    winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder,CursorLine:CursorLine",
                }),
            },

            -- Formatting with icons and source labels
            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = lspkind.cmp_format({
                    mode = "symbol_text",
                    maxwidth = 60,
                    ellipsis_char = "…",
                    symbol_map = {
                        Text = "󰦨",
                        Method = "󰆧",
                        Function = "󰊕",
                        Constructor = "󰈏",
                        Field = "󰜢",
                        Variable = "󰀫",
                        Class = "󰠱",
                        Interface = "󰕘",
                        Module = "󰏗",
                        Property = "󰜢",
                        Unit = "󰑭",
                        Value = "󰎠",
                        Enum = "󰕘",
                        Keyword = "󰌋",
                        Snippet = "󰩫",
                        Color = "󰏘",
                        File = "󰈙",
                        Reference = "󰈇",
                        Folder = "󰉋",
                        EnumMember = "󰕘",
                        Constant = "󰏿",
                        Struct = "󰙅",
                        Event = "󰗆",
                        Operator = "󰆕",
                        TypeParameter = "󰊄",
                    },
                    menu = {
                        codeium = " AI",
                        luasnip = " Snip",
                        buffer = "󰦨 Buf",
                        path = "󰉋 Path",
                        nvim_lsp = "󰀫 LSP",
                        nvim_lsp_signature_help = "󰌵 Sig",
                    },
                }),
            },

            -- Key mappings
            mapping = cmp.mapping.preset.insert({
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ["<C-j>"] = cmp.mapping.select_next_item(),
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
            }),

            -- Sources
            sources = cmp.config.sources({
                { name = "codeium" },
                { name = "luasnip" },
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" },
                { name = "nvim_lsp_signature_help" },
            }),
        })

        -- Gruvbox-inspired transparent highlights
        vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE", fg = "#ebdbb2" })
        vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#504945", fg = "#fabd2f" })
        vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "#3c3836" })
        vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#fabd2f" })
        vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE", fg = "#928374" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", fg = "#ebdbb2" })
        vim.api.nvim_set_hl(0, "CursorLine", { bg = "#3c3836" })
        vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#fabd2f", bold = true })
        vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#fabd2f", bold = true })
        vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#83A598" })
        vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#8EC07C" })
        vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#D3869B" })
        vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#B8BB26" })
        vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#928374", italic = true })

        -- Full hover + signature help keymaps
        vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("i", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { noremap = true, silent = true })

        -- Optional: Resize hover popup for full Rust docs
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
            vim.lsp.handlers.hover,
            {
                border = "rounded",
                max_width = 80,
                max_height = 20,
                focusable = false,
            }
        )

        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
            vim.lsp.handlers.signature_help,
            {
                border = "rounded",
                max_width = 80,
                max_height = 10,
                focusable = false,
            }
        )
    end,
}
