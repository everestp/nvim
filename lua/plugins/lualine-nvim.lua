return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim" },
  config = function()
    local Job = require("plenary.job")

    -- ==========================================================
    -- 📰 Latest Crypto News (via NewsData.io — BTC only, 100 chars)
    -- ==========================================================
    local crypto_news = "Loading…"
    local function update_crypto_news()
      Job:new({
        command = "curl",
        args = {
          "-s",
          "https://newsdata.io/api/1/crypto?apikey=pub_bb5ecbbdee774b81bf63180b5925fc5b&language=en"
        },
        on_exit = function(job, return_val)
          if return_val == 0 then
            local result = table.concat(job:result(), "")
            local ok, data = pcall(vim.json.decode, result)
            if ok and data and data.results and #data.results > 0 and data.results[1].title then
              local title = data.results[1].title
              crypto_news = #title > 100 and title:sub(1, 97) .. "..." or title
            else
              crypto_news = "News: N/A"
            end
          else
            crypto_news = "News: Err"
          end
          vim.schedule(function()
            vim.cmd("redrawstatus")
          end)
        end,
      }):start()
    end

    vim.fn.timer_start(1800000, update_crypto_news, { ["repeat"] = -1 })
    update_crypto_news()

    local function crypto_news_component()
      return "📰 " .. crypto_news
    end

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
              btc_price = data.bitcoin.usd
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

    vim.fn.timer_start(170000, update_btc_price, { ["repeat"] = -1 })
    update_btc_price()

    -- ==========================================================
    -- 🧮 Helper: Format number with commas
    -- ==========================================================
    local function format_with_commas(amount)
      local formatted = tostring(amount)
      local k
      while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
        if k == 0 then break end
      end
      return formatted
    end

    -- ==========================================================
    -- 💵 BTC Price Component
    -- ==========================================================
    local function btc_price_component()
      local num = tonumber(btc_price or 0)
      if num and num > 0 then
        return "₿ $" .. format_with_commas(string.format("%.2f", num))
      else
        return "₿ " .. btc_price
      end
    end

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
    -- 🕓 Date & Time Component (Full Year)
    -- ==========================================================
    local function datetime()
      return os.date(" %b %d, %Y  %H:%M")
    end

    -- ==========================================================
    -- 🎨 Soft Gruvbox Dark Colors
    -- ==========================================================
    local colors = {
      bg0     = "#1d2021",
      bg1     = "#3c3836",
      fg_dark = "#ebdbb2",
      fg_soft = "#bdae93",
      fg_gray = "#928374",
      red     = "#fb4934",
      green   = "#b8bb26",
      yellow  = "#fabd2f",
      blue    = "#83a598",
      magenta = "#d3869b",
      orange  = "#fe8019",
      mode_normal  = "#1d2021",
      mode_insert  = "#2a2c26",
      mode_visual  = "#32302f",
      mode_replace = "#3c3836",
      mode_command = "#2e2a25",
    }

    -- ==========================================================
    -- ⚡ Lualine Theme
    -- ==========================================================
    local my_lualine_theme = {
      normal = { a = { bg = colors.mode_normal, fg = colors.blue, gui = "bold" },
                 b = { bg = colors.bg1, fg = colors.fg_soft },
                 c = { bg = colors.bg0, fg = colors.fg_dark },
                 x = { bg = colors.bg1, fg = colors.fg_soft },
                 y = { bg = colors.bg1, fg = colors.fg_soft },
                 z = { bg = colors.bg1, fg = colors.fg_soft } },
      insert  = { a = { bg = colors.mode_insert, fg = colors.green, gui = "bold" } },
      visual  = { a = { bg = colors.mode_visual, fg = colors.yellow, gui = "bold" } },
      replace = { a = { bg = colors.mode_replace, fg = colors.red, gui = "bold" } },
      command = { a = { bg = colors.mode_command, fg = colors.orange, gui = "bold" } },
      inactive= { a = { bg = colors.bg0, fg = colors.fg_gray },
                  b = { bg = colors.bg0, fg = colors.fg_gray },
                  c = { bg = colors.bg0, fg = colors.fg_gray } },
    }

    -- ==========================================================
    -- ⚙️ Lualine Setup (Updated Layout)
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
          { "filename", path = 0, symbols = { modified = "", readonly = "", unnamed = "" }, color = { fg = colors.fg_dark } },
          { lsp_client, color = { fg = colors.blue, gui = "bold" } },
        },
        lualine_x = {
          { "diagnostics", sources = { "nvim_diagnostic" }, symbols = { error = " ", warn = " ", info = " ", hint = " " } },
          { word_count, color = { fg = colors.fg_soft } },
          { crypto_news_component, color = { fg = colors.magenta, gui = "italic" } },
        },
        lualine_y = { { "progress" } },
        lualine_z = {
          { datetime, color = { fg = colors.fg_soft } },
          { btc_price_component, color = { fg = colors.yellow, gui = "bold" } },
        },
      },
      extensions = { "fugitive", "nvim-tree", "toggleterm", "quickfix" },
    })
  end,
}
