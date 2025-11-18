-- ================================================================================================
-- TITLE : nvim-cmp + LSP + Diagnostics Ultimate Setup (Gruvbox)
-- ABOUT : Transparent completion, hover docs, signature help, short inline errors, full popup
-- ================================================================================================

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "onsails/lspkind.nvim",
        "saadparwaiz1/cmp_luasnip",
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
            build = "make install_jsregexp",
        },
        "rafamadriz/friendly-snippets",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "neovim/nvim-lspconfig",
    },

    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")
        local lspconfig = require("lspconfig")

        require("luasnip.loaders.from_vscode").lazy_load()

        -----------------------------
        -- CMP setup
        -----------------------------
        cmp.setup({
            snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
            window = {
                completion = cmp.config.window.bordered({
                    border = "rounded",
                    winhighlight = "NormalFloat:Pmenu,FloatBorder:FloatBorder,CursorLine:CursorLine",
                }),
                documentation = cmp.config.window.bordered({
                    border = "rounded",
                    winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder,CursorLine:CursorLine",
                }),
            },
            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = lspkind.cmp_format({
                    mode = "symbol_text",
                    maxwidth = 60,
                    ellipsis_char = "…",
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
            mapping = cmp.mapping.preset.insert({
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ["<C-j>"] = cmp.mapping.select_next_item(),
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources({
                { name = "codeium" },
                { name = "luasnip" },
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" },
                { name = "nvim_lsp_signature_help" },
            }),
        })

        -----------------------------
        -- Gruvbox highlights
        -----------------------------
        local function set_hl(group, opts) vim.api.nvim_set_hl(0, group, opts) end
        set_hl("Pmenu", { bg = "NONE", fg = "#ebdbb2" })
        set_hl("PmenuSel", { bg = "#504945", fg = "#fabd2f" })
        set_hl("PmenuSbar", { bg = "#3c3836" })
        set_hl("PmenuThumb", { bg = "#fabd2f" })
        set_hl("FloatBorder", { bg = "NONE", fg = "#928374" })
        set_hl("NormalFloat", { bg = "NONE", fg = "#ebdbb2" })
        set_hl("CursorLine", { bg = "#3c3836" })
        set_hl("CmpItemAbbrMatch", { fg = "#fabd2f", bold = true })
        set_hl("CmpItemKindFunction", { fg = "#83A598" })
        set_hl("CmpItemKindMethod", { fg = "#8EC07C" })
        set_hl("CmpItemKindVariable", { fg = "#D3869B" })
        set_hl("CmpItemKindSnippet", { fg = "#B8BB26" })
        set_hl("CmpItemMenu", { fg = "#928374", italic = true })

        -----------------------------
        -- Diagnostics: short inline + full popup
        -----------------------------
        vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticError" })
        vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticWarn" })
        vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticInfo" })
        vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticHint" })

        vim.diagnostic.config({
            virtual_text = {
                prefix = "●",
                spacing = 2,
                source = false,
                severity = { min = vim.diagnostic.severity.HINT },
                format = function(d)
                    local msg = d.message:gsub("\n", " ")
                    if #msg > 50 then msg = msg:sub(1, 50) .. "…" end
                    return msg
                end,
            },
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
        })

        set_hl("DiagnosticError", { fg = "#fb4934" })
        set_hl("DiagnosticWarn", { fg = "#fabd2f" })
        set_hl("DiagnosticInfo", { fg = "#83a598" })
        set_hl("DiagnosticHint", { fg = "#b8bb26" })

        vim.api.nvim_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { noremap=true, silent=true })
        vim.api.nvim_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { noremap=true, silent=true })
        vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float(nil, { border='rounded' })<CR>", { noremap=true, silent=true })

        -----------------------------
        -- Hover & signature help
        -----------------------------
        vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap=true, silent=true })
        vim.api.nvim_set_keymap("i", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { noremap=true, silent=true })

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "rounded", max_width = 80, max_height = 20, focusable = false
        })
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = "rounded", max_width = 80, max_height = 10, focusable = false
        })

        -----------------------------
        -- Rust Analyzer LSP
        -----------------------------
        lspconfig.rust_analyzer.setup({
            settings = { ["rust-analyzer"] = { checkOnSave = { command = "clippy" } } },
        })
    end,
}
