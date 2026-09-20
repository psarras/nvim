function ColorMyPencils(color)
	color = color or "catppuccin"

	-- Match the desktop's current Catppuccin flavor (mocha/latte), which
	-- ~/.config/theme/apply-theme.sh writes to this plain-text state file.
	-- Absent on Windows (no OS-level theme switcher there), so default to mocha.
	local flavour = "mocha"
	local flavour_file = vim.fn.expand("~/.config/theme/current-flavour")
	if vim.fn.filereadable(flavour_file) == 1 then
		local read = vim.fn.trim(vim.fn.readfile(flavour_file)[1] or "")
		if read == "mocha" or read == "latte" then
			flavour = read
		end
	end
	require("catppuccin").setup({ flavour = flavour })

	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()
