local vim = vim

if vim.g.neovide then
	vim.o.guifont = "Consolas"
	vim.opt.linespace = 0
	vim.g.neovide_scale_factor = 0.8
	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0
	vim.g.neovide_transparency = 1.0
	vim.g.neovide_scroll_animation_length = 0.2

	-- disable cursor animations
	vim.g.neovide_cursor_animation_length = 0
	vim.g.neovide_cursor_trail_size = 0
	vim.g.neovide_cursor_animate_in_insert_mode = false
	vim.g.neovide_cursor_animate_command_line = false
end
