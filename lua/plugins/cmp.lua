return {
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		--"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-omni",
		"saadparwaiz1/cmp_luasnip",
		{
			"roobert/tailwindcss-colorizer-cmp.nvim",
			config = function()
				require("tailwindcss-colorizer-cmp").setup({
					color_square_width = 2,
				})
			end,
		},
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local mylatexSource = require("custom-cmp")

		local kindIcons = {
			Class = "",
			Color = "",
			Constant = "",
			Constructor = "",
			Enum = "",
			EnumMember = "",
			Event = "",
			Field = "",
			File = "",
			Folder = "",
			Function = "",
			Interface = "",
			Keyword = "",
			Method = "",
			Module = "",
			Operator = "",
			Property = "",
			Reference = "",
			Snippet = "",
			Struct = "",
			Text = "",
			TypeParameter = "",
			Unit = "",
			Value = "",
			Variable = "",
		}
		local function border(hl_name)
			return {
				{ "╭", hl_name },
				{ "─", hl_name },
				{ "╮", hl_name },
				{ "│", hl_name },
				{ "╯", hl_name },
				{ "─", hl_name },
				{ "╰", hl_name },
				{ "│", hl_name },
			}
		end

		-- @param entry cmp.Entry 期望的字符串参数
		-- @param item any 期望的数字参数
		local function formatter(entry, item)
			item.kind = " " .. kindIcons[item.kind] .. " "
			item.menu = "[" .. entry.source.name .. "]"
			return item
		end
		vim.api.nvim_set_hl(0, "MyBorder", { fg = "#C971CC", bold = true })

		cmp.setup({
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = formatter,
			},
			window = {
				completion = {
					border = border("MyBorder"),
					side_padding = 0,
					col_offset = -3,
					winhighlight = "Normal:Normal,Search:None",
					max_height = 5,
				},
			},

			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
					-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
					-- vim.snippet.expand(args.body)
					--	require("snippy").expand_snippet(args.body) -- For `snippy` users.
					-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
				end,
			},
			mapping = {
				["<C-p>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif not cmp.visible() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "c" }),
				["<C-n>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif not cmp.visible() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "c" }),
				["<C-c>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.abort()
					elseif not cmp.visible() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "c" }),
				["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					--vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if luasnip.jumpable(-1) then
						luasnip.jump(-1)
					--vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
					else
						fallback()
					end
				end, { "i", "s" }),
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "nvim_lua" },
				{ name = "codeium" },
				{
					name = "omni",
				},
				-- { name = "snp" },
				{ name = "luasnip" },
				-- { name = "snippets" },
				-- { name = "mylatex" },
				-- { name = "vimtex" },
			}, {
				{ name = "buffer" },
			}),
		})
		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{
					name = "buffer",
					option = {
						get_bufnrs = function()
							return vim.api.nvim_list_bufs()
						end,
					},
				},
			},
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
		})
		cmp.setup.filetype("tex", {
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "mylatex" },
				{ name = "omini" },
				{ name = "buffer" },
				{ name = "luasnip" },
			}),
		})

		cmp.register_source("mylatex", mylatexSource)
	end,
}
