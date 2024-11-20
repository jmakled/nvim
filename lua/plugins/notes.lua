return {
	{
		"mfussenegger/nvim-lint",
		enabled = false,
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",

		dependencies = {
			"nvim-lua/plenary.nvim", -- Required
			"folke/which-key.nvim", -- opt
			"hrsh7th/nvim-cmp", -- opt
		},

		opts = {
			workspaces = {
				{
					name = "notes",
					path = "$NOTE_DIR",
				},
				{
					name = "code",
					path = "~/Code",
					overrides = {
						templates = {
							folder = vim.NIL,
						},
						daily_notes = {
							folder = vim.NIL,
						},
						disable_frontmatter = true,
					},
				},
			},

			daily_notes = {
				folder = "journal/daily_pages/" .. os.date("%Y") .. "/",
				date_format = "%Y-%m-%d",
				alias_format = "%B %-d, %Y",
				default_tags = { "daily-page" },
				template = "Page - Daily Page.md",
			},

			-- Completion of links and tags using nvim-cmp.
			completion = {
				nvim_cmp = true,
				min_chars = 2,
			},

			-- Where to put new notes - "current_dir" or "notes_subdir"
			new_notes_location = "current_dir",

			-- Customizing note IDs via given title
			---@param title string|?
			---@return string
			note_id_func = function(title)
				-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
				-- 'My new note' = '1657296016-my-new-note'
				local suffix = ""
				if title ~= nil then
					-- If title is given, transform it into valid file name.
					suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
				else
					-- If title is nil, just add 4 random uppercase letters to the suffix.
					for _ = 1, 4 do
						suffix = suffix .. string.char(math.random(65, 90))
					end
				end
				return tostring(os.date("%Y-%m-%d")) .. "-" .. suffix
			end,

			-- Wikilink formatting
			--  * "use_alias_only"      - '[[Foo Bar]]'
			--  * "prepend_note_id"     - '[[foo-bar|Foo Bar]]'
			--  * "prepend_note_path"   - '[[foo-bar.md|Foo Bar]]'
			--  * "use_path_only"       - '[[foo-bar.md]]'
			preferred_link_style = "wiki",
			wiki_link_fun = "prepend_note_path",

			-- Optional, alternatively you can customize the frontmatter data.
			---@return table
			note_frontmatter_func = function(note)
				-- Add the title of the note as an alias.
				if note.title then
					note:add_alias(note.title)
				end

				local out = {
					id = note.id,
					aliases = note.aliases,
					tags = note.tags,
					status = note.status or "draft",
					created = note.created or os.date("%Y-%m-%dT%H:%M:%S"),
				}

				-- `note.metadata` contains any manually added fields in the frontmatter.
				-- So here we just make sure those fields are kept in the frontmatter.
				if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
					for k, v in pairs(note.metadata) do
						out[k] = v
					end
				end

				return out
			end,

			-- Optional, for templates (see below).
			templates = {
				folder = "templates",
				date_format = "%Y-%m-%d",
				time_format = "%I:%M %p",
				-- A map for custom variable:function pairs
				substitutions = {
					-- NOTE: these weird keywords are Obsidian syntax
					--       these substitutions bridge the gap btwn app & nvim

					["date:dddd"] = function()
						return os.date("%A") -- Full weekday name
					end,

					["date:Do"] = function()
						local day = tonumber(os.date("%-d")) -- day w/o leading zero
						local suffix = (function()
							if day % 10 == 1 and day ~= 11 then
								return "st"
							elseif day % 10 == 2 and day ~= 12 then
								return "nd"
							elseif day % 10 == 3 and day ~= 13 then
								return "rd"
							else
								return "th"
							end
						end)()
						return day .. suffix -- day suffix; 1st, 4th, 22nd, etc
					end,

					["date:MMMM"] = function()
						return os.date("%B") -- Full month name
					end,

					["time:hh:mm A"] = function()
						return os.date("%I:%M %p") -- Format time as "08:12 PM"
					end,
				},
			},

			---@param url string
			follow_url_func = function(url)
				-- Open URLs in default web browser.
				vim.ui.open(url) -- WARN: req. nvim 0.10+
			end,

			picker = {
				name = "fzf-lua",
			},

			-- Show notes sorted by latest modified time
			sort_by = "modified",
			sort_reversed = true,

			-- UI disabled; doesn't play nice with LazyVim Markdown extra
			-- see: https://github.com/MeanderingProgrammer/render-markdown.nvim?tab=readme-ov-file#obsidiannvim
			ui = {
				enable = false,
			},

			-- Specify how to handle attachments.
			attachments = {
				img_folder = "attachments", -- relative to vault root
			},
		},

		config = function(_, opts)
			require("obsidian").setup(opts)

			-- which-key
			local wk = require("which-key")

			wk.add({
				{ "<leader>o", group = "Obsidian" },
				{ "<leader>oo", "<cmd>ObsidianQuickSwitch<CR>", desc = "Quick switch" },
				{ "<leader>ot", "<cmd>ObsidianTemplate<CR>", desc = "Insert Template" },
				{ "<c-t>", "<cmd>ObsidianTemplate<CR>", desc = "Insert Template", mode = { "n", "i" } },
				{ "<leader>on", "<cmd>ObsidianNew<CR>", desc = "New Note" },
				{ "<leader>oN", "<cmd>ObsidianNewFromTemplate<CR>", desc = "New Note from Template" },
				{ "<leader>or", "<cmd>ObsidianRename<CR>", desc = "Rename" },
				{ "<leader>oo", "<cmd>ObsidianQuickSwitch<CR>", desc = "Quick switch" },
				-- { "<leader>oo", "<cmd>ObsidianOpen<CR>", desc = "Open note" },
				{ "<leader>os", "<cmd>ObsidianSearch<CR>", desc = "Search" },
				{ "<leader>oa", "<cmd>ObsidianTags<CR>", desc = "Tags" },
				-- { "<leader>oi", "<cmd>ObsidianPasteImg<CR>", desc = "Paste image" }, -- not sure I'll ever use this, leaving for now

				-- Page Linking
				{ "<leader>oc", "<cmd>ObsidianTOC<CR>", desc = "Table of Contents" },
				{ "<leader>ol", "<cmd>ObsidianLinks<CR>", desc = "Links" },
				{ "<leader>ob", "<cmd>ObsidianBacklinks<CR>", desc = "Backlinks" },

				-- Daily Pages
				{ "<leader>od", group = "Daily Pages" },
				{ "<leader>oD", "<cmd>ObsidianToday<CR>", desc = "Today" },
				{ "<leader>odt", "<cmd>ObsidianToday<CR>", desc = "Today" },
				{ "<leader>odr", "<cmd>ObsidianDailies -10 0<CR>", desc = "Recent Daily Pages" },
			})
		end,
	},
}
