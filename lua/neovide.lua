local vim = vim

if vim.g.neovide then
	vim.o.guifont = "JetBrainsMono Nerd Font Mono"
	vim.opt.linespace = 0
	vim.g.neovide_scale_factor = 0.75
	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0
	vim.g.neovide_transparency = 1.0
end
