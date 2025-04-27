local vim = vim

-- Load core modules
require("vim_options")
require("keymaps")
require("utils")
require("autocmd")
require("neovide")
require("themes")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

-- Setup leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{
			"neovim/nvim-lspconfig",
			config = function()
				local on_attach = function(client, bufnr)
					local nmap = function(keys, func, desc)
						if desc then
							desc = "LSP: " .. desc
						end
						vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
					end

					nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
					nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
					nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					nmap(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					nmap("K", vim.lsp.buf.hover, "Hover Documentation")
					nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
					nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
					nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
					nmap("<leader>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, "[W]orkspace [L]ist Folders")

					vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
						vim.lsp.buf.format()
					end, { desc = "Format current buffer with LSP" })
				end

				vim.diagnostic.config({
					virtual_text = false,
					signs = true,
					underline = false,
					update_in_insert = false,
					severity_sort = true,
				})

				vim.api.nvim_set_keymap(
					"n",
					"D",
					"<cmd>lua require('utils').show_diagnostics_popup()<cr>",
					{ noremap = true, silent = true }
				)

				local servers = {
					pyright = {},
					rust_analyzer = {},
					ts_ls = {},
					zls = {},
					lua_ls = {
						Lua = {
							workspace = { checkThirdParty = false },
							telemetry = { enable = false },
						},
					},
					gopls = {
						settings = {
							gopls = {
								analyses = {
									unusedparams = true,
								},
								staticcheck = true,
							},
						},
					},
					texlab = {},
					ocamlls = {
						cmd = { "ocamllsp" },
						filetypes = { "ocaml", "reason" },
						root_dir = function(fname)
							return require("lspconfig.util").root_pattern("dune")(fname)
								or require("lspconfig.util").path.dirname(fname)
						end,
					},
				}

				local capabilities = vim.lsp.protocol.make_client_capabilities()
				capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

				local mason = require("mason")
				mason.setup()

				local mason_lspconfig = require("mason-lspconfig")
				mason_lspconfig.setup({
					ensure_installed = vim.tbl_keys(servers),
				})

				mason_lspconfig.setup_handlers({
					function(server_name)
						require("lspconfig")[server_name].setup({
							capabilities = capabilities,
							on_attach = on_attach,
							settings = servers[server_name],
						})
					end,
				})
			end,
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				"hrsh7th/nvim-cmp",
				"williamboman/mason.nvim",
				"williamboman/mason-lspconfig.nvim",
				"L3MON4D3/LuaSnip",
			},
		},
		{
			"hrsh7th/nvim-cmp",
			config = function()
				local cmp = require("cmp")

				cmp.setup({
					snippet = {
						expand = function(args)
							require("luasnip").lsp_expand(args.body)
						end,
					},
					window = {
						completion = cmp.config.window.bordered(),
						documentation = cmp.config.window.bordered(),
					},
					mapping = {
						["<Tab>"] = cmp.mapping(function(fallback)
							local copilot = require("copilot.suggestion")

							if copilot.is_visible() then
								copilot.accept()
							elseif cmp.visible() then
								cmp.select_next_item()
							else
								fallback()
							end
						end, { "i", "s" }),
						["<S-Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_prev_item()
							else
								fallback()
							end
						end, { "i", "s" }),
						["<CR>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.confirm({ select = true })
							else
								fallback()
							end
						end, { "i", "s" }),
					},
					sources = {
						{ name = "luasnip", group_index = 2, priority = 500 },
						{ name = "nvim_lsp", group_index = 2, priority = 500 },
						{ name = "path", group_index = 1000 },
					},
				})

				cmp.setup.cmdline({ "/", "?" }, {
					mapping = cmp.mapping.preset.cmdline(),
					sources = {
						{ name = "buffer" },
					},
				})

				cmp.setup.cmdline(":", {
					mapping = cmp.mapping.preset.cmdline(),
					sources = cmp.config.sources({
						{ name = "path" },
					}, {
						{ name = "cmdline" },
					}),
					matching = { disallow_symbol_nonprefix_matching = false },
				})
			end,
			dependencies = {
				"neovim/nvim-lspconfig",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
			},
		},
		{
			"zbirenbaum/copilot.lua",
			cmd = "Copilot",
			event = "InsertEnter",
			opts = {
				panel = { enabled = false },
				suggestion = {
					auto_trigger = true,
					keymap = {
						accept = false,
						accept_word = "<M-w>",
						accept_line = "<M-l>",
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "/",
					},
				},
				filetypes = { markdown = true },
			},
			config = function(_, opts)
				local cmp = require("cmp")
				local copilot = require("copilot.suggestion")
				local luasnip = require("luasnip")

				require("copilot").setup(opts)

				local function set_trigger(trigger)
					vim.b.copilot_suggestion_auto_trigger = trigger
					vim.b.copilot_suggestion_hidden = not trigger
				end

				cmp.event:on("menu_opened", function()
					if copilot.is_visible() then
						copilot.dismiss()
					end
					set_trigger(false)
				end)

				cmp.event:on("menu_closed", function()
					set_trigger(not luasnip.expand_or_locally_jumpable())
				end)
				vim.api.nvim_create_autocmd("User", {
					pattern = { "LuasnipInsertNodeEnter", "LuasnipInsertNodeLeave" },
					callback = function()
						set_trigger(not luasnip.expand_or_locally_jumpable())
					end,
				})
			end,
		},
		{
			"mhartington/formatter.nvim",
			config = function()
				local util = require("formatter.util")
				require("formatter").setup({
					logging = false,
					filetype = {
						lua = {
							function()
								return {
									exe = "stylua",
									args = {
										"--search-parent-directories",
										"--stdin-filepath",
										util.escape_path(util.get_current_buffer_file_path()),
										"--",
										"-",
									},
									stdin = true,
								}
							end,
						},
						python = {
							function()
								return {
									exe = "black",
									args = { "-q", "-" },
									stdin = true,
								}
							end,
						},
						rust = {
							function()
								return {
									exe = "rustfmt",
									args = { "--emit=stdout" },
									stdin = true,
								}
							end,
						},
						zig = {
							function()
								return {
									exe = "zig fmt",
									args = {
										util.escape_path(util.get_current_buffer_file_path()),
									},
								}
							end,
						},
						cpp = {
							function()
								return {
									exe = "clang-format",
									args = {
										"-i",
										util.escape_path(util.get_current_buffer_file_path()),
									},
								}
							end,
						},
						ocaml = {
							function()
								return {
									exe = "ocamlformat",
									args = {
										"--name",
										util.escape_path(util.get_current_buffer_file_path()),
										"--inplace",
										"-",
									},
									stdin = true,
								}
							end,
						},
					},
				})
			end,
		},
		{
			"nvim-telescope/telescope.nvim",
			config = function()
				require("telescope").setup({
					defaults = {
						mappings = {
							i = {
								["<C-u>"] = false,
								["<C-d>"] = false,
							},
						},
						sorting_strategy = "ascending",
						layout_strategy = "vertical",
						layout_config = {
							horizontal = {
								prompt_position = "top",
								preview_width = 0.55,
								results_width = 0.5,
							},
							vertical = {
								prompt_position = "top",
								mirror = false,
							},
							width = 0.50,
							height = 0.50,
							preview_cutoff = 120,
						},
					},
				})

				pcall(require("telescope").load_extension, "fzf")

				vim.keymap.set(
					"n",
					"<leader>?",
					require("telescope.builtin").oldfiles,
					{ desc = "[?] Find recently opened files" }
				)
				vim.keymap.set(
					"n",
					"<leader><space>",
					require("telescope.builtin").buffers,
					{ desc = "[ ] Find existing buffers" }
				)
				vim.keymap.set("n", "<leader>/", function()
					require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
						winblend = 10,
						previewer = false,
					}))
				end, { desc = "[/] Fuzzily search in current buffer" })

				vim.keymap.set(
					"n",
					"<leader>fgf",
					require("telescope.builtin").git_files,
					{ desc = "Search [G]it [F]iles" }
				)
				vim.keymap.set(
					"n",
					"<leader>ff",
					require("telescope.builtin").find_files,
					{ desc = "[S]earch [F]iles" }
				)
				vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
				vim.keymap.set(
					"n",
					"<leader>fcw",
					require("telescope.builtin").grep_string,
					{ desc = "[S]earch current [W]ord" }
				)
				vim.keymap.set(
					"n",
					"<leader>fw",
					require("telescope.builtin").live_grep,
					{ desc = "[S]earch by [G]rep" }
				)
				vim.keymap.set(
					"n",
					"<leader>fd",
					require("telescope.builtin").diagnostics,
					{ desc = "[S]earch [D]iagnostics" }
				)
				vim.keymap.set("n", "<leader>fp", "<cmd>Telescope neovim-project discover<cr>", { silent = true })
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter",
			lazy = false,
			run = ":TSUpdate",
			config = function()
				require("nvim-treesitter.configs").setup({
					highlight = {
						enable = true,
						additional_vim_regex_highlighting = true,
					},
				})
			end,
		},
		{
			"RRethy/vim-illuminate",
			config = function()
				require("illuminate").configure({})
			end,
		},
		{
			"qpkorr/vim-bufkill",
			config = function()
				vim.keymap.set("n", "<leader>c", ":BD<CR>", opts)
			end,
		},
		{
			"coffebar/neovim-project",
			opts = {
				projects = {
					"~/.config/nvim",
					"~/code/codecrafters-redis-zig",
					"~/code/rreddis",
					"~/note",
					"~/code/zig/mat",
					"~/code/zig/aoc2024",
					"~/code/daily-challenges/",
					"~/.config/ghostty/",
					"~/code/neetcode",
					"~/note",
					"~/code/SetFindr/",
					"~/code/setfindr-backend/",
					"~/code/GearBO/",
					"~/code/gearbo-backend/",
					"~/code/zml/",
				},
			},
			init = function()
				vim.opt.sessionoptions:append("globals")
			end,
			dependencies = {
				{ "nvim-lua/plenary.nvim" },
				{ "nvim-telescope/telescope.nvim", tag = "0.1.4" },
				{ "Shatur/neovim-session-manager" },
			},
			lazy = false,
			priority = 100,
		},
		{
			"robitx/gp.nvim",
			config = function()
				require("gp").setup({
					openai_api_key = os.getenv("OPENAI_API_KEY"),
					github_token = function()
						local token_command = {
							"bash",
							"-c",
							'cat ~/.config/github-copilot/hosts.json | grep -o \'"oauth_token": *"[^"]*"\' | sed \'s/.*": *"//\' | tr -d \'"\'',
						}
						local handle = io.popen(table.concat(token_command, " "))
						local result = handle:read("*a")
						handle:close()
						return result:gsub("%s+", "")
					end,
				})
			end,
		},
		{
			"stevearc/oil.nvim",
			opts = {
				skip_confirm_for_simple_edits = true,
				view_options = { show_hidden = true },
				columns = {
					"icon",
					"permissions",
					"size",
					"mtime",
				},
			},
		},
		{
			"lewis6991/gitsigns.nvim",
			config = function()
				require("gitsigns").setup()
			end,
		},
		{ "marko-cerovac/material.nvim" },
		{ "folke/tokyonight.nvim" },
		{ "morhetz/gruvbox" },
		{ "craftzdog/solarized-osaka.nvim" },
		{ "Mofiqul/vscode.nvim" },
		{
			"xiyaowong/transparent.nvim",
			lazy = false,
			config = function()
				require("transparent").setup({})
			end,
		},
		{
			"nvimdev/lspsaga.nvim",
			config = function()
				require("lspsaga").setup({})
			end,
		},
		{ "MeanderingProgrammer/render-markdown.nvim", opts = {} },
		{ "m4xshen/autoclose.nvim", opts = {} },
		{
			"hadronized/hop.nvim",
			config = function()
				require("hop").setup({})
				vim.keymap.set("n", "<leader>w", "<cmd>HopWord<CR>", { silent = true })
			end,
		},
		{ "norcalli/nvim-colorizer.lua" },
		{ "karb94/neoscroll.nvim", opts = {} },
		{
			"lervag/vimtex",
			config = function()
				vim.g.vimtex_view_method = "zathura"
				vim.g.maplocalleader = ","
			end,
		},
		{
			"dlants/magenta.nvim",
			lazy = false, -- you could also bind to <leader>mt
			build = "npm install --frozen-lockfile",
			opts = {},
		},
		{
			"greggh/claude-code.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim", -- Required for git operations
			},
			opts = {
				-- Terminal window settings
				window = {
					height_ratio = 0.3, -- Percentage of screen height for the terminal window
					position = "botright", -- Position of the window: "botright", "topleft", etc.
					enter_insert = true, -- Whether to enter insert mode when opening Claude Code
					hide_numbers = true, -- Hide line numbers in the terminal window
					hide_signcolumn = true, -- Hide the sign column in the terminal window
				},
				-- File refresh settings
				refresh = {
					enable = true, -- Enable file change detection
					updatetime = 100, -- updatetime when Claude Code is active (milliseconds)
					timer_interval = 1000, -- How often to check for file changes (milliseconds)
					show_notifications = true, -- Show notification when files are reloaded
				},
				-- Git project settings
				git = {
					use_git_root = true, -- Set CWD to git root when opening Claude Code (if in git project)
				},
				-- Command settings
				command = "claude", -- Command used to launch Claude Code
				-- Keymaps
				keymaps = {
					toggle = {
						normal = "<C-,>", -- Normal mode keymap for toggling Claude Code, false to disable
						terminal = "<C-,>", -- Terminal mode keymap for toggling Claude Code, false to disable
					},
					window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
					scrolling = true, -- Enable scrolling keymaps (<C-f/b>) for page up/down
				},
			},
		},
		{
			"yetone/avante.nvim",
			event = "VeryLazy",
			version = false, -- Never set this value to "*"! Never!
			opts = {
				-- add any opts here
				-- for example
				-- provider = "openai",
				-- openai = {
				-- 	endpoint = "https://api.openai.com/v1",
				-- 	model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
				-- 	timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
				-- 	temperature = 0,
				-- 	max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
				-- 	--reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
				-- },
			},
			-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
			build = "make",
			-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
				"stevearc/dressing.nvim",
				"nvim-lua/plenary.nvim",
				"MunifTanjim/nui.nvim",
				--- The below dependencies are optional,
				"echasnovski/mini.pick", -- for file_selector provider mini.pick
				"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
				"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
				"ibhagwan/fzf-lua", -- for file_selector provider fzf
				"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
				"zbirenbaum/copilot.lua", -- for providers='copilot'
				{
					-- support for image pasting
					"HakonHarnes/img-clip.nvim",
					event = "VeryLazy",
					opts = {
						-- recommended settings
						default = {
							embed_image_as_base64 = false,
							prompt_for_file_name = false,
							drag_and_drop = {
								insert_mode = true,
							},
							-- required for Windows users
							use_absolute_path = true,
						},
					},
				},
				{
					-- Make sure to set this up properly if you have lazy=true
					"MeanderingProgrammer/render-markdown.nvim",
					opts = {
						file_types = { "markdown", "Avante" },
					},
					ft = { "markdown", "Avante" },
				},
			},
		},
	},
	checker = { enabled = true },
})

vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"

vim.cmd.colorscheme("vscode")

vim.keymap.set("n", "<leader>e", ":Oil<CR>", { silent = true })

vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_view_general_options = [[--synctex-forward @line:@col:@tex @pdf]]
vim.g.vimtex_compiler_method = "latexmk"
