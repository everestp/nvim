-- ================================================================================================
-- TITLE : neo-tree.nvim
-- ABOUT : Modern, fast, and highly customizable file explorer for Neovim.
-- LINKS :
--   > github : https://github.com/nvim-neo-tree/neo-tree.nvim
-- ================================================================================================

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  config = function()
    -- Remove background for transparent themes
    vim.cmd([[hi NeoTreeNormal guibg=NONE ctermbg=NONE]])
    vim.cmd([[hi NeoTreeNormalNC guibg=NONE ctermbg=NONE]])

    require("neo-tree").setup({
      close_if_last_window = true, -- Close Neo-tree if it's the last window open
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,

      filesystem = {
        bind_to_cwd = true,
        follow_current_file = { enabled = true },
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },

      window = {
        position = "left",
        width = 32,
        mappings = {
          ["<space>"] = "toggle_node",
          ["<cr>"] = "open",           -- Press Enter to open file
          ["s"] = "open_vsplit",       -- Split vertically
          ["S"] = "open_split",        -- Split horizontally
          ["q"] = "close_window",      -- Close Neo-tree window
          ["R"] = "refresh",           -- Refresh view
        },
      },

      default_component_configs = {
        indent = {
          padding = 0,
          with_markers = true,
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "󰜌",
        },
        git_status = {
          symbols = {
            added     = "",
            modified  = "",
            deleted   = "✖",
            renamed   = "󰁕",
            untracked = "",
            ignored   = "",
            unstaged  = "󰄱",
            staged    = "",
            conflict  = "",
          },
        },
      },
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>e", "<Cmd>Neotree toggle<CR>", { desc = "Toggle NeoTree" })
    vim.keymap.set("n", "<leader>o", "<Cmd>Neotree focus<CR>", { desc = "Focus NeoTree" })
  end,
}
