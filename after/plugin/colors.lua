function ColorMyPencils(color)
	color = color or "catppuccin"

	-- Match the desktop's current Catppuccin flavor (mocha/latte), which
	-- ~/.config/theme/apply-theme.sh keeps in sync via rofi's current-flavor
	-- symlink — reusing that rather than a new state file of our own.
	local flavour = "mocha"
	local link = vim.fn.resolve(vim.fn.expand("~/.config/rofi/current-flavor.rasi"))
	if link:find("latte") then
		flavour = "latte"
	end
	require("catppuccin").setup({ flavour = flavour })

	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()
