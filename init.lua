local vim = vim

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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins

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
					-- nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
					nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					nmap(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)

					-- See `:help K` for why this keymap
					nmap("K", vim.lsp.buf.hover, "Hover Documentation")
					nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

					-- Lesser used LSP functionality
					nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
					nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
					nmap("<leader>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, "[W]orkspace [L]ist Folders")

					-- Create a command `:Format` local to the LSP buffer
					vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
						vim.lsp.buf.format()
					end, { desc = "Format current buffer with LSP" })
				end

				-- Disable virtual text for LSP diagnostics by default
				vim.diagnostic.config({
					virtual_text = false,
					signs = true,
					underline = false,
					update_in_insert = false,
					severity_sort = true,
				})

				-- Map the D key to show diagnostics popup
				vim.api.nvim_set_keymap(
					"n",
					"D",
					"<cmd>lua require('utils').show_diagnostics_popup()<cr>",
					{ noremap = true, silent = true }
				)

				local servers = {
					-- clangd = {},
					-- gopls = {},
					-- markdown_languageserver = {},
					pyright = {},
					rust_analyzer = {},
					ts_ls = {},
					-- jsonlint = {},
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
					texlab = {
						-- settings = {
						-- 	texlab = {
						-- 		build = {
						-- 			executable = "latexmk",
						-- 			args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
						-- 			onSave = true,
						-- 		},
						-- 	},
						-- },
					},
				}

				-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
				local capabilities = vim.lsp.protocol.make_client_capabilities()
				capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

				-- setup mason before setting up mason-lspconfig
				local mason = require("mason")
				mason.setup()

				-- Ensure the servers above are installed
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
							require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
						end,
					},
					window = {
						completion = cmp.config.window.bordered(),
						documentation = cmp.config.window.bordered(),
					},
					mapping = {
						-- Navigate through suggestions
						["<Tab>"] = cmp.mapping(function(fallback)
							local copilot = require("copilot.suggestion")

							if copilot.is_visible() then
								copilot.accept()
							elseif cmp.visible() then
								cmp.select_next_item()
							-- elseif luasnip.expand_or_locally_jumpable() then
							-- 	luasnip.expand_or_jump()
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

						-- Confirm completion - nevermind, doesn't work.
						["<CR>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.confirm({ select = true })
							else
								fallback()
							end
						end, { "i", "s" }),
					},

					sources = {
						-- { name = "copilot", group_index = 2, priority = 1000 },
						{ name = "luasnip", group_index = 2, priority = 500 },
						{ name = "nvim_lsp", group_index = 2, priority = 500 },
						{ name = "path", group_index = 1000 },
					},
				})

				-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
				cmp.setup.cmdline({ "/", "?" }, {
					mapping = cmp.mapping.preset.cmdline(),
					sources = {
						{ name = "buffer" },
					},
				})

				-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
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
				-- I don't find the panel useful.
				panel = { enabled = false },
				suggestion = {
					auto_trigger = true,
					-- Use alt to interact with Copilot.
					keymap = {
						-- Disable the built-in mapping, we'll configure it in nvim-cmp.
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

				-- Hide suggestions when the completion menu is open.
				cmp.event:on("menu_opened", function()
					if copilot.is_visible() then
						copilot.dismiss()
					end
					set_trigger(false)
				end)

				-- Disable suggestions when inside a snippet.
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
						-- javascript = {
						-- 	function()
						-- 		return {
						-- 			exe = "prettier",
						-- 			args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
						-- 			stdin = true,
						-- 		}
						-- 	end,
						-- },
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
					},
				})
			end,
		},

		{
			-- the one and the only
			"nvim-telescope/telescope.nvim",
			config = function()
				-- [[ Configure Telescope ]]
				-- See `:help telescope` and `:help telescope.setup()`
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

				-- Enable telescope fzf native, if installed
				pcall(require("telescope").load_extension, "fzf")

				-- See `:help telescope.builtin`
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
					-- You can pass additional configuration to telescope to change theme, layout, etc.
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
			-- highlight symbols
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

		-- manual but manages session as well
		{
			"coffebar/neovim-project",
			opts = {
				-- define project roots
				projects = {
					"~/.config/nvim",
					"~/code/codecrafters-redis-zig",
					"~/code/rreddis",
					"~/note",
					"~/code/zig/mat",
					"~/code/zig/aoc2024",
					"~/code/daily-challenges/",
					"~/code/ocaml/project_name",
					"~/.config/ghostty/",
					"~/code/neetcode",
				},
			},
			init = function()
				-- enable saving the state of plugins in the session
				vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
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
					-- Optional configuration
					openai_api_key = os.getenv("OPENAI_API_KEY"),

					-- GitHub Copilot configuration
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

		--colorschemes
		{ "marko-cerovac/material.nvim" },
		{ "folke/tokyonight.nvim" },

		-- { "bdesham/biogoo" },
		-- { "yasukotelin/notelight" },
		-- { "mgutz/vim-colors" },
		-- { "lunacookies/vim-corvine" },
		-- { "weih/vim-mac-classic-alt" },
		-- { "conweller/endarkened.vim" },
		-- { "j201/stainless" },

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

		{
			"HiPhish/rainbow-delimiters.nvim",
			lazy = false,
			config = function()
				require("rainbow-delimiters.setup").setup({})
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

		-- plugins end here
		{ "norcalli/nvim-colorizer.lua" },

		-- smooth scrolling
		{ "karb94/neoscroll.nvim", opts = {} },

		-- VimTeX for LaTeX editing
		{
			"lervag/vimtex",
			config = function()
				vim.g.vimtex_view_method = "zathura" -- Set Zathura as the PDF viewer
				vim.g.maplocalleader = "," -- Set local leader key to ","
			end,
		},
	},

	-- Configure any other settings here. See the documentation for more details.
	-- automatically check for plugin updates
	checker = { enabled = true },
})

vim.cmd.colorscheme("modus_operandi")

vim.keymap.set("n", "<leader>e", ":Oil<CR>", { silent = true })

vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_view_general_options = [[--synctex-forward @line:@col:@tex @pdf]]
vim.g.vimtex_compiler_method = "latexmk"
