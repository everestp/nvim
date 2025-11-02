-- ================================================================================================
-- TITLE : gruvbox.nvim
-- ABOUT : A retro groove color scheme for Neovim inspired by the Gruvbox theme.
-- LINKS :
--   > github : https://github.com/ellisonleao/gruvbox.nvim
-- ================================================================================================

return {
	"ellisonleao/gruvbox.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("gruvbox").setup({
			contrast = "hard", -- can be "hard", "soft" or empty string
			transparent_mode = false, -- set true if you use transparent background
		})
		vim.cmd("colorscheme gruvbox")
	end,
}
