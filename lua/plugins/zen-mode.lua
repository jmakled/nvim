return {
	-- TODO: Zen Mode oughta kick in automatically in $NOTE_DIR
	"folke/zen-mode.nvim",
	keys = {
		{ "<leader>uz", "<cmd>ZenMode<CR>", desc = "Toggle Zen Mode" },
	},
	opts = {
		window = {
			backdrop = 1, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal

			-- * % of the width / height of the editor when <= 1
			width = 0.9, -- width of the Zen window
			height = 0.85, -- height of the Zen window
			options = {
				-- signcolumn = "yes", -- disable signcolumn
				number = false, -- disable number column
				relativenumber = false, -- disable relative numbers
				cursorline = false, -- disable cursorline
				cursorcolumn = false, -- disable cursor column
				-- foldcolumn = "0", -- disable fold column
				list = false, -- disable whitespace characters
			},
		},
		plugins = {
			options = {
				enabled = true,
				ruler = false, -- disables the ruler text in the cmd line area
				showcmd = false, -- disables the command in the last line of the screen
				-- statusline will be shown only if 'laststatus' == 3
				laststatus = 0,
			},
			gitsigns = { enabled = true }, -- disables git signs
			tmux = { enabled = true }, -- disables the tmux statusline
			todo = { enabled = false }, -- if set to "true", todo-comments.nvim highlights will be disabled
		},
	},
}
