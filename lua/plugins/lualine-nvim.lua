-- ================================================================================================
-- TITLE : lualine.nvim (Soft Gruvbox Dark Inspired)
-- ABOUT : Low-distraction dark theme focusing on readability and subtle mode changes.
-- ================================================================================================

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim" },
  config = function()
    local Job = require("plenary.job")

    -- ==========================================================
    -- 💰 Live Bitcoin (BTC) Price (via CoinGecko)
    -- ==========================================================
    local btc_price = "..."
    local function update_btc_price()
      Job:new({
        command = "curl",
        args = {
          "-s",
          "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd",
        },
        on_exit = function(job, return_val)
          if return_val == 0 then
            local result = table.concat(job:result(), "")
            local ok, data = pcall(vim.json.decode, result)
            if ok and data and data.bitcoin and data.bitcoin.usd then
              btc_price = string.format("$%.2f", data.bitcoin.usd)
            else
              btc_price = "N/A"
            end
          else
            btc_price = "Err"
          end
          vim.schedule(function()
            vim.cmd("redrawstatus")
          end)
        end,
      }):start()
    end

    vim.fn.timer_start(300000, update_btc_price, { ["repeat"] = -1 })
    update_btc_price()

    -- ==========================================================
    -- 📚 LSP Client Component
    -- ==========================================================
    local function lsp_client()
      local clients = vim.lsp.get_active_clients({ bufnr = 0 })
      if next(clients) == nil then
        return "LSP: None"
      end
      local names = {}
      for _, client in ipairs(clients) do
        table.insert(names, client.name)
      end
      return "  " .. table.concat(names, ", ")
    end

    -- ==========================================================
    -- 📝 Word Count (for text files only)
    -- ==========================================================
    local function word_count()
      local ft = vim.opt_local.filetype:get()
      local count_filetypes = {
        markdown = true,
        text = true,
        tex = true,
        pandoc = true,
        wiki = true,
      }

      if count_filetypes[ft] then
        local words = vim.fn.wordcount().words
        return "W: " .. words
      else
        return ""
      end
    end

    -- ==========================================================
    -- 🕓 Date & Time Component
    -- ==========================================================
    local function datetime()
      return os.date(" %b %d  %H:%M")
    end

    -- ==========================================================
    -- 🎨 Soft Gruvbox Dark Colors
    -- ==========================================================
    local colors = {
      -- Backgrounds
      bg0     = "#1d2021", -- primary dark background
      bg1     = "#3c3836", -- secondary section background

      -- Foreground / Text
      fg_dark = "#ebdbb2", -- main text
      fg_soft = "#bdae93", -- muted text
      fg_gray = "#928374", -- tertiary / subtle text

      -- Accent Colors
      red     = "#fb4934", -- replace/error
      green   = "#b8bb26", -- insert/added
      yellow  = "#fabd2f", -- visual/BTC
      blue    = "#83a598", -- LSP
      magenta = "#d3869b", -- location/highlights
      orange  = "#fe8019", -- command/warning
    }

    -- Define lualine theme
    local my_lualine_theme = {
      normal = {
        a = { bg = colors.bg0, fg = colors.blue, gui = "bold" },
        b = { bg = colors.bg1, fg = colors.fg_soft },
        c = { bg = colors.bg0, fg = colors.fg_dark },
        x = { bg = colors.bg1, fg = colors.fg_soft },
        y = { bg = colors.bg1, fg = colors.fg_soft },
        z = { bg = colors.bg1, fg = colors.fg_soft },
      },
      insert  = { a = { bg = colors.bg0, fg = colors.green, gui = "bold" } },
      visual  = { a = { bg = colors.bg0, fg = colors.yellow, gui = "bold" } },
      replace = { a = { bg = colors.bg0, fg = colors.red, gui = "bold" } },
      command = { a = { bg = colors.bg0, fg = colors.orange, gui = "bold" } },
      inactive = {
        a = { bg = colors.bg0, fg = colors.fg_gray },
        b = { bg = colors.bg0, fg = colors.fg_gray },
        c = { bg = colors.bg0, fg = colors.fg_gray },
      },
    }

    -- ==========================================================
    -- ⚙️ Lualine Setup
    -- ==========================================================
    require("lualine").setup({
      options = {
        theme = my_lualine_theme,
        globalstatus = true,
        icons_enabled = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "NvimTree", "neo-tree", "packer" },
        always_divide_middle = true,
        refresh = { statusline = 100 },
      },
      sections = {
        lualine_a = { { "mode", icon = "" } },
        lualine_b = {
          { "branch", icon = "" },
          { "diff", symbols = { added = " ", modified = "", removed = " " } },
        },
        lualine_c = {
          { "filename", path = 1, symbols = { modified = "", readonly = "", unnamed = "" }, color = { fg = colors.fg_dark } },
          { lsp_client, color = { fg = colors.blue, gui = "bold" } },
        },
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
          },
          { word_count, color = { fg = colors.fg_soft } },
          {
            function() return "₿ " .. btc_price end,
            color = { fg = colors.yellow, gui = "bold" },
          },
        },
        lualine_y = { { "progress" } },
        lualine_z = { { datetime, color = { fg = colors.fg_soft } }, { "location", icon = "" } },
      },
      extensions = { "fugitive", "nvim-tree", "toggleterm", "quickfix" },
    })
  end,
}
