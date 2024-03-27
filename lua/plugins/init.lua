-- User for NvimTree
local gwidth = vim.api.nvim_list_uis()[1].width
local gheight = vim.api.nvim_list_uis()[1].height
local width = 60
local height = 40

-- Use for Markdown/Headline
vim.cmd([[highlight Bullet guifg=#333333]])
vim.cmd([[highlight Headline1 guibg=#111111 guifg=#d93929 gui=bold]])
vim.cmd([[highlight Headline2 guibg=#111111 guifg=#00ffa5 gui=bold]])
vim.cmd([[highlight Headline3 guibg=#111111 guifg=#00ebd7]])
vim.cmd([[highlight Headline4 guibg=#111111 guifg=#00d5f2 gui=italic]])
vim.cmd([[highlight CodeBlock guibg=#111111]])
vim.cmd([[highlight Dash guibg=#232323 guifg=#222222 gui=bold]])
vim.cmd([[highlight Quote guifg=#ffffc9]])

return {
	-- Visual
	{
		event = "VeryLazy",
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{
		event = "VeryLazy",
		"thenbe/markdown-todo.nvim",
		ft = { "md", "mdx", "markdown" },
		config = true,
	},
	{
		event = "VeryLazy",
		"lukas-reineke/headlines.nvim",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			require("headlines").setup({
				markdown = {
					bullets = { "", "✸", "◉", "✿" },
					bullet_highlights = {
						"Bullet",
					},
					quote_highlight = "Quote",
					headline_highlights = {
						"Headline1",
						"Headline2",
						"Headline3",
						"Headline4",
						"CodeBlock",
						"Dash",
					},
				},
			})
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		opts = function(_, opts)
			opts.git.enable = true
			opts.actions.open_file.quit_on_open = true
			opts.filters.dotfiles = true
			opts.view.float = {
				enable = true,
				quit_on_focus_loss = true,
				open_win_config = {
					relative = "editor",
					width = width,
					height = height,
					row = (gheight - height) * 0.4,
					col = (gwidth - width) * 0.95,
					border = "rounded",
				},
			}
			opts.view.side = "right"
			opts.view.width = width
			opts.view.height = height
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = { "MunifTanjim/nui.nvim" },
		config = function()
			require("noice").setup({
				presets = {
					bottom_search = false, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
				lsp = {
					signature = {
						enabled = false,
					},
					hover = {
						enabled = false,
					},
				},
				progress = {
					enabled = false,
				},
				signature = { enabled = false },
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = false,
					["vim.lsp.util.stylize_markdown"] = false,
					["cmp.entry.get_documentation"] = false, -- requires hrsh7th/nvim-cmp
				},
			})
		end,
		init = function()
			vim.g.lsp_handlers_enabled = false
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		optional = true,
		dependencies = { "jay-babu/project.nvim" },
		opts = function(_, opts)
			opts.patterns = { ".git" }
			require("telescope").load_extension("projects")
		end,
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		dependencies = "nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
		main = "rainbow-delimiters.setup",
	},
	{
		event = "VeryLazy",
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup({})
		end,
	},
	{
		"jay-babu/project.nvim",
		main = "project_nvim",
		event = "VeryLazy",
		opts = { ignore_lsp = { "lua_ls" } },
	},

	-- Utils
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		config = function()
			require("harpoon").setup()
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{
				"<leader>a",
				function()
					require("harpoon"):list():append()
				end,
				desc = "Harpoon - Add file",
			},
			{
				"<leader><leader>e",
				function()
					require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
				end,
				desc = "Harpoon - Toggle quick menu",
			},
		},
	},
	{
		"stevearc/conform.nvim",
		config = function()
			require("configs.conform")
		end,
	},
	{
		{
			"kdheepak/lazygit.nvim",
			cmd = {
				"LazyGit",
				"LazyGitConfig",
				"LazyGitCurrentFile",
				"LazyGitFilter",
				"LazyGitFilterCurrentFile",
			},
			-- optional for floating window border decoration
			dependencies = {
				"nvim-telescope/telescope.nvim",
			},
		},
	},
	{
		"luckasRanarison/tailwind-tools.nvim",
		event = "VeryLazy",
		opts = {
			document_color = {
				enabled = true,
				kind = "inline",
				inline_symbol = "󰝤 ",
				debounce = 200,
			},
			conceal = {
				enabled = true,
				symbol = "󱏿",
				highlight = {
					fg = "#38BDF8",
				},
			},
		},
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"luckasRanarison/tailwind-tools.nvim", -- TODO change for luckasRanarison/tailwind-tools.nvim
			"onsails/lspkind-nvim",
		},
		opts = function(_, opts)
			opts.formatting.format = require("lspkind").cmp_format({
				before = require("tailwind-tools.cmp").lspkind_format,
			})
		end,
	},
	{
		"echasnovski/mini.surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("mini.surround").setup()
		end,
	},
	{
		"echasnovski/mini.cursorword",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("mini.cursorword").setup()
		end,
	},

	{
		"echasnovski/mini.move",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("mini.move").setup()
		end,
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"ray-x/lsp_signature.nvim",
			opts = {
				hint_enable = true, -- disable hints as it will crash in some terminal
			},
		},
	},

	-- Override plugin definition options
	{
		"nvim-treesitter/nvim-treesitter",
		opts = require("configs.treesitter"),
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"windwp/nvim-ts-autotag",
		},
	},
	{
		"williamboman/mason.nvim",
		opts = require("configs.mason"),
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("nvchad.configs.lspconfig")
			require("configs.lspconfig")
		end, -- Override to setup mason-lspconfig
	},

	-- Better code action UI
	{
		"nvimdev/lspsaga.nvim",
		event = "LspAttach",
		config = function()
			require("lspsaga").setup({})
		end,
	},
}
