return {
  "ray-x/go.nvim",
  dependencies = { "ray-x/guihua.lua" },
  ft = { "go", "gomod" },
  config = function()
    require("go").setup({
      lsp_cfg = false, -- because we already configure gopls
      lsp_gofumpt = true,
    })
  end,
}
