-- ~/.config/nvim/lua/config/keymaps.lua

-- ========================
-- Leader Key
-- ========================
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable default Space behavior
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

local opts = { noremap = true, silent = true }

-- ========================
-- File Operations
-- ========================
vim.keymap.set('n', '<C-s>', '<cmd>w<CR>', opts)                  -- Save file
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w<CR>', opts) -- Save w/o formatting
vim.keymap.set('n', '<C-q>', '<cmd>q<CR>', opts)                -- Quit
vim.keymap.set('n', '<leader>wq', '<cmd>wq<CR>', opts)          -- Save & quit

-- ========================
-- Editing
-- ========================
vim.keymap.set('n', 'x', '"_x', opts)           -- Delete char without affecting register
vim.keymap.set('v', 'p', '"_dP', opts)         -- Keep yanked text when pasting
vim.keymap.set('v', '<', '<gv', opts)          -- Stay in indent mode
vim.keymap.set('v', '>', '>gv', opts)

-- ========================
-- Motion & Text Objects (NEW ADDITIONS)
-- ========================
-- Quick start/end of line
vim.keymap.set('n', 'H', '^', opts)
vim.keymap.set('n', 'L', '$', opts)
-- System Clipboard access (using "+ register)
vim.keymap.set('n', '<leader>y', '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = "Yank line to system clipboard" })
vim.keymap.set('n', '<leader>p', '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set('n', '<leader>P', '"+P', { desc = "Paste before from system clipboard" })

-- ========================
-- Visual Mode (NEW ADDITIONS)
-- ========================
-- Re-indent a visual selection
vim.keymap.set('v', '<leader>=', "<cmd>='<,'>normal ==<CR>", { desc = "Re-indent selection" })

-- ========================
-- Scrolling & Searching
-- ========================
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- ========================
-- Window Management
-- ========================
vim.keymap.set('n', '<leader>v', '<C-w>v', opts)  -- Vertical split
vim.keymap.set('n', '<leader>h', '<C-w>s', opts)  -- Horizontal split
vim.keymap.set('n', '<leader>se', '<C-w>=', opts) -- Equalize splits
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts) -- Close current split

-- Navigate splits easily
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- Resize splits
vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', opts)

-- ========================
-- Tabs
-- ========================
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts)
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts)
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts)
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts)

-- ========================
-- Buffers
-- ========================
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', opts)
vim.keymap.set('n', '<leader>b', ':enew<CR>', opts)

-- ========================
-- Telescope (fuzzy finder)
-- ========================
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts)
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', opts)
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<CR>', opts)
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opts)
vim.keymap.set('n', '<leader>fp', function()
  require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
end, { desc = "Find Plugin File" })

-- ========================
-- LSP & Diagnostics
-- ========================
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = "Go to Declaration" })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = "Find References" })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = "Go to Implementation" })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename Symbol" })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = "Show Diagnostic" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Diagnostics List" })
-- LSP (NEW ADDITIONS)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "LSP Hover (Documentation)" })
vim.keymap.set('n', '<leader>fm', function()
  vim.lsp.buf.format({ async = true })
end, { desc = "LSP Format Buffer" })

-- ========================
-- Git (gitsigns)
-- ========================
vim.keymap.set('n', '<leader>gs', ':Gitsigns stage_hunk<CR>', opts)
vim.keymap.set('n', '<leader>gu', ':Gitsigns undo_stage_hunk<CR>', opts)
vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', opts)
vim.keymap.set('n', '<leader>gb', ':Gitsigns blame_line<CR>', opts)

-- ========================
-- ToggleTerm
-- ========================
vim.keymap.set('n', '<leader>tt', ':ToggleTerm<CR>', opts)
vim.keymap.set('t', '<leader>tt', '<C-\\><C-n>:ToggleTerm<CR>', opts)

-- ========================
-- Misc
-- ========================
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts) -- toggle line wrap
vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<CR>', opts) -- undo tree
vim.keymap.set('n', '<leader>tr', '<cmd>TroubleToggle<CR>', opts) -- toggle trouble
-- Utility & Toggles (NEW ADDITIONS)
vim.keymap.set('n', '<leader>nn', '<cmd>set nu! rnu!<CR>', { desc = "Toggle line numbers" })
vim.keymap.set('n', '<leader>hl', '<cmd>set hlsearch!<CR>', { desc = "Toggle search highlight" })
vim.keymap.set('n', '<leader>sp', '<cmd>set spell!<CR>', { desc = "Toggle spell check" })
vim.keymap.set('n', '<leader>r', 'do <C-r>', opts) -- Redo