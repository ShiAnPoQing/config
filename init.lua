local R = require("repeat")
local base = require("base-function")

require("auto-command")
require("options").setup()
-- require("history-function").setup()
require("parse-keymap").setup({
	add = {
		["<F7>"] = {
			function()
				require("test").insertPre()
			end,
			"n",
		},
		[";rs"] = {
			function()
				R.RecordStart()
			end,
			"n",
		},
		[";re"] = {
			function()
				R.RecordEnd()
			end,
			"n",
		},
		[";rf"] = {
			function()
				R.RepeatTriggerFixed()
			end,
			"n",
		},

		-- ["<F8>"] = {
		-- function()
		-- require("test").expand()
		-- end,
		-- "n",
		-- },
		-- ["<S-Tab>"] = {
		-- function()
		-- if vim.snippet.active({ direction = -1 }) then
		-- vim.snippet.jump(-1)
		-- else
		-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true), "nt", true)
		-- end
		-- end,
		-- { "i", "s" },
		-- },
		-- ["<Tab>"] = {
		-- {
		-- function()
		-- local luasnip = require("luasnip")
		-- local expand = luasnip.isExpandable()

		-- if not expand then
		-- if vim.snippet.active({ direction = 1 }) then
		-- vim.snippet.jump(1)
		-- else
		-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "nt", true)
		-- end
		-- else
		-- expand()
		-- end
		-- end,
		-- { "i", "s" },
		-- },
		-- {
		-- function()
		-- local luasnip = require("luasnip")
		-- local expand = luasnip.isExpandable()

		-- if not expand then
		-- if vim.snippet.active({ direction = 1 }) then
		-- vim.snippet.jump(1)
		-- else
		-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "nt", true)
		-- end
		-- else
		-- expand()
		-- end
		-- end,
		-- { "x" },
		-- },
		-- },

		-- repeat
		["."] = {
			function()
				require("repeat").Repeat()
			end,
			"n",
		},
		["<leader>sl"] = {
			{
				function()
					local S = require("sort-line")
					S.sortLineByLength("n")
					R.Record(function()
						S.sortLineByLength("n")
					end)
				end,
				"n",
			},
			{
				function()
					local S = require("sort-line")
					S.sortLineByLength("v")
					R.Record(function()
						S.sortLineByLength("v")
					end)
				end,
				"x",
			},
		},

		-- Run lsp codelens
		["<leader>lc"] = {
			function()
				vim.lsp.codelens.run()
			end,
			"n",
			{ desc = "[L]sp [C]odelens" },
		},
		-- Refresh lsp codelens
		["<leader>cR"] = {
			function()
				vim.lsp.codelens.refresh()
			end,
			"n",
		},
		-- Goto next in QuickFix List
		["<leader>qn"] = {
			"<cmd>cnext<cr>zz",
			"n",
		},
		-- Goto prev in QuickFix List
		["<leader>qp"] = {
			"<cmd>cprevious<cr>zz",
			"n",
		},
		-- Open QuickFix List
		["<leader>qo"] = {
			"<cmd>copen<cr>zz",
			"n",
		},
		-- Close QuickFix List
		["<leader>qc"] = {
			"<cmd>cclose<cr>zz",
			"n",
		},
		-- QuickFix List show diagnostic
		["<leader>dq"] = {
			function()
				vim.diagnostic.setqflist()
			end,
			"n",
		},
		-- Open diagnostic Float Win
		["<leader>df"] = {
			function()
				vim.diagnostic.open_float({
					border = "rounded",
				})
			end,
			"n",
		},
		-- Goto prev WARN diagnostic
		["[w"] = {
			function()
				vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
				vim.api.nvim_feedkeys("zz", "n", false)
			end,
			"n",
		},
		-- Goto next WARN diagnostic
		["]w"] = {
			function()
				vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
				vim.api.nvim_feedkeys("zz", "n", false)
			end,
			"n",
		},
		-- Goto next error diagnostic
		["]e"] = {
			function()
				vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
				vim.api.nvim_feedkeys("zz", "n", false)
			end,
			"n",
		},
		-- Goto previous error diagnostic
		["[e"] = {
			function()
				vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
				vim.api.nvim_feedkeys("zz", "n", false)
			end,
			"n",
		},
		["[d"] = {
			function()
				vim.diagnostic.goto_prev({})
				vim.api.nvim_feedkeys("zz", "n", false)
			end,
			"n",
		},
		["]d"] = {
			function()
				vim.diagnostic.goto_next({})
				vim.api.nvim_feedkeys("zz", "n", false)
			end,
			"n",
		},
		-- show inlay_hint
		["<leader>ih"] = {
			function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
			end,
			"n",
		},
		-- search cursor text
		["*"] = { "*zz", "n" },
		-- search cursor text
		["#"] = { "#zz", "n" },
		--["%"] = { "%zz", "n" },
		-- select all
		["<C-a>"] = {
			"ggVG",
			"n",
		},
		-- search visual text
		["<space>/"] = {
			'y/<C-R>"<CR>',
			"x",
		},
		-- Replace word under cursor
		["<space>s"] = {
			{
				[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
				"n",
			},
			{
				[[:s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
				"x",
			},
		},
		-- Keep window centered when going up/down
		["n"] = {
			"nzzzv",
			"n",
		},
		["N"] = {
			"Nzzzv",
			"n",
		},
		-- copy file name
		["<leader>cf"] = {
			'<cmd>let @+ = expand("%")<CR>',
			{ "n" },
		},
		-- copy file path
		["<leader>cp"] = {
			'<cmd>let @+ = expand("%:p")<CR>',
			{ "n" },
		},
		-- line connect
		["<space><space><BS>"] = {
			function()
				local L = require("line-connect")
				local count = vim.v.count1
				L.LineConnect(count, "n", "al")
				vim.api.nvim_feedkeys("_", "n", false)

				R.Record(function()
					L.LineConnect(count, "n", "al")
					vim.api.nvim_feedkeys("_", "n", false)
				end)
			end,
			{ "n" },
			{ expr = true },
		},
		-- @line connect + move
		["<space><BS>"] = {
			{
				function()
					local L = require("line-connect")
					local count = vim.v.count1
					L.LineConnect(count, "n", "")
					R.Record(function()
						L.LineConnect(count, "n", "")
					end)
				end,
				"n",
				{ expr = true },
			},
			{
				function()
					local L = require("line-connect")
					local count = vim.v.count1
					L.LineConnect(count, "x", "al")
					R.Record(function()
						L.LineConnect(count, "x", "al")
					end)
				end,
				{ "x" },
				{ expr = true },
			},
		},
		-- Line Break
		["<space><CR>"] = {
			{
				function()
					local L = require("line-break")
					local count = vim.v.count1
					L.LineBreak(count, "n", "al")
					R.Record(function()
						L.LineBreak(count, "n", "al")
					end)
				end,
				{ "n" },
				{ expr = true },
			},
			{
				function()
					local L = require("line-break")
					local count = vim.v.count1
					L.LineBreak(count, "v", "al")
					R.Record(function()
						L.LineBreak(count, "v", "al")
					end)
				end,
				{ "x" },
				{ expr = true },
			},
		},
		-- jump the middle of cursor to left
		["<space>am"] = {
			function()
				local count = vim.v.count1
				base.JumpToMiddle(count, "left")
				R.Record(function()
					base.JumpToMiddle(count, "left")
				end)
			end,
			"n",
		},
		-- jump the middle of cursor to right
		["<space><space>am"] = {
			function()
				local count = vim.v.count1
				base.JumpToMiddle(count, "right")
				R.Record(function()
					base.JumpToMiddle(count, "right")
				end)
			end,
			"n",
		},
		-- jump the middle of cursor to top
		["<space>an"] = {
			function()
				local count = vim.v.count1
				base.JumpToMiddle(count, "up")
				R.Record(function()
					base.JumpToMiddle(count, "up")
				end)
			end,
			"n",
		},
		-- jump the middle of cursor to bottom
		["<space><space>an"] = {
			function()
				local count = vim.v.count1
				base.JumpToMiddle(count, "down")
				R.Record(function()
					base.JumpToMiddle(count, "down")
				end)
			end,
			"n",
		},
		-- enlarge base cursor move
		["m+"] = {
			function()
				local M = require("change-movesize")
				local count = vim.v.count1
				M.ChangeMoveSize(count, "up")
				R.Record(function()
					M.ChangeMoveSize(count, "up")
				end)
			end,
			{ "n" },
		},
		-- reduce base cursor move
		["m-"] = {
			function()
				local M = require("change-movesize")
				local count = vim.v.count1
				M.ChangeMoveSize(count, "down")
				R.Record(function()
					M.ChangeMoveSize(count, "down")
				end)
			end,
			{ "n" },
		},
		-- reset base cursor move
		["m<BS>"] = {
			function()
				require("change-movesize").ChangeMoveSize_reset()
			end,
			{ "n" },
		},
		-- clone up line with word step
		["<M-S-w>"] = {
			{
				function()
					local M = require("copy-line-word")
					local count = vim.v.count1
					M.CopyLineWord("up", count, "i")
					R.Record(function()
						M.CopyLineWord("up", count, "i")
					end)
				end,
				"i",
			},

			{
				function()
					local M = require("copy-line-word")
					local count = vim.v.count1
					M.CopyLineWord("up", count, "n")
					R.Record(function()
						M.CopyLineWord("up", count, "n")
					end)
				end,
				"n",
			},
		},
		-- clone down line with word step
		["<M-S-e>"] = {
			{
				function()
					local M = require("copy-line-word")
					local count = vim.v.count1
					M.CopyLineWord("down", count, "i")
					R.Record(function()
						M.CopyLineWord("down", count, "i")
					end)
				end,
				"i",
			},
			{
				function()
					local M = require("copy-line-word")
					local count = vim.v.count1
					M.CopyLineWord("down", count, "n")
					R.Record(function()
						M.CopyLineWord("down", count, "n")
					end)
				end,
				"n",
			},
		},
		-- clone up line with single letter
		["<M-w>"] = {
			"<C-y>",
			"i",
		},
		-- clone down line with single letter
		["<M-e>"] = {
			"<C-e>",
			"i",
		},
		-- exchange window
		["<M-x>"] = {
			function()
				require("win-action").windowExchange()
			end,
			"n",
		},
		-- jump window
		["<M-g>"] = {
			function()
				require("win-action").windowJump()
			end,
			"n",
		},
		-- show file info
		[";sfi"] = {
			function()
				local S = require("show-file-info")
				S.showFileInfo()
				R.Record(function()
					S.showFileInfo()
				end)
			end,
			"n",
		},
		-- show press key
		[";sk"] = {
			function()
				local K = require("key-show")
				K.keyShow()
				R.Record(function()
					K.keyShow()
				end)
			end,
			"n",
		},
		-- hidden press key show
		[";hk"] = {
			function()
				require("key-show").keyHide()
			end,
			"n",
		},
		["<C-F10>"] = {
			function()
				require("search-manual").searchManual()
			end,
			"n",
		},
		-- open myvimrc
		[";<F5>"] = { ":e $MYVIMRC<cr>", "n", { desc = "Edit my neovim config" } },
		-- toggle comment
		["<C-\\>"] = {
			{
				function()
					local C = require("comment")
					local count = vim.v.count1
					C.toggleComment("n", count)
					R.Record(function()
						C.toggleComment("n", count)
					end)
				end,
				"n",
			},
			{
				function()
					local C = require("comment")
					local count = vim.v.count1
					C.toggleComment("v", count)
					R.Record(function()
						C.toggleComment("v", count)
					end)
				end,
				"x",
			},
			{
				function()
					local C = require("comment")
					local count = vim.v.count1
					C.toggleComment("n", count)
					R.Record(function()
						C.toggleComment("n", count)
					end)
				end,
				"i",
			},
		},
		[";tm"] = {
			{
				function()
					local T = require("text-align")
					T.textAlign({
						align = "middle",
						mode = "n",
					})
					R.Record(function()
						T.textAlign({
							align = "middle",
							mode = "n",
						})
					end)
				end,
				"n",
			},
			{
				function()
					local T = require("text-align")
					T.textAlign({
						align = "middle",
						mode = "v",
					})
					R.Record(function()
						T.textAlign({
							align = "middle",
							mode = "v",
						})
					end)
				end,
				"x",
			},
		},
		[";tl"] = {
			{
				function()
					local T = require("text-align")
					T.textAlign({
						align = "right",
						mode = "n",
					})
					R.Record(function()
						T.textAlign({
							align = "right",
							mode = "n",
						})
					end)
				end,
				"n",
			},
			{
				function()
					local T = require("text-align")
					T.textAlign({
						align = "right",
						mode = "v",
					})
					R.Record(function()
						T.textAlign({
							align = "right",
							mode = "v",
						})
					end)
				end,
				"x",
			},
		},
		[";th"] = {
			{
				function()
					local T = require("text-align")
					T.textAlign({
						align = "left",
						mode = "n",
					})
					R.Record(function()
						T.textAlign({
							align = "left",
							mode = "n",
						})
					end)
				end,
				"n",
			},
			{
				function()
					local T = require("text-align")
					T.textAlign({
						align = "left",
						mode = "v",
					})
					R.Record(function()
						T.textAlign({
							align = "left",
							mode = "v",
						})
					end)
				end,
				"x",
			},
		},
		[";ig"] = {
			function()
				require("switch-function").switch("ignorecase")
			end,
			{ "n" },
		},
		-- toggle list icon
		[";li"] = {
			function()
				require("switch-function").switch("list")
			end,
			{ "n" },
		},
		-- toggle hlsearch highlight
		[";hl"] = {
			function()
				require("switch-function").switch("hlsearch")
			end,
			{ "n" },
		},
		["<F9>"] = {
			function()
				base.expand()
			end,
			{ "i" },
		},

		-- normal mode cursor move: Home(without space)
		["<space>w"] = {
			{
				function()
					return base.EnterInertMode("n", "left")
				end,
				{ "n" },
			},
			{
				function()
					return base.EnterInertMode("v", "left")
				end,
				{ "x" },
			},
			{
				function()
					return base.EnterInertMode("s", "left")
				end,
				{ "s" },
			},
		},
		-- normal mode cursor move: End(without space)
		["<space>e"] = {
			{
				function()
					return base.EnterInertMode("n", "right")
				end,
				{ "n" },
			},
			{
				function()
					return base.EnterInertMode("v", "right")
				end,
				{ "x" },
			},
			{
				function()
					return base.EnterInertMode("s", "right")
				end,
				{ "s" },
			},
		},
		-- add new line below cursor line, and cursor jump new line
		["<M-b>"] = {
			function()
				local count = vim.v.count1
				base.AddNewLine(count, "down")
				R.Record(function()
					base.AddNewLine(count, "down")
				end)
			end,
			"n",
		},
		-- add new line above cursor line, and cursor jump new line
		["<C-b>"] = {
			{
				function()
					local count = vim.v.count1
					base.AddNewLine(count, "up")
					R.Record(function()
						base.AddNewLine(count, "up")
					end)
				end,
				"n",
			},
			{
				function()
					local count = vim.v.count1
					base.AddNewLine(count, "up")
					R.Record(function()
						base.AddNewLine(count, "up")
					end)
				end,
				"i",
			},
		},
		-- del line start space
		[";db<space>"] = {
			{
				function()
					local D = require("del-space")
					local count = vim.vim.count1
					D.delSpace(count, "n")
					R.Record(function()
						D.delSpace(count, "n")
					end)
				end,
				{ "n" },
			},
			{
				function()
					local D = require("del-space")
					local count = vim.vim.count1
					D.delSpace(count, "v")
					R.Record(function()
						D.delSpace(count, "v")
					end)
				end,
				{ "v" },
			},
		},
		-- move line(s): Down
		["<C-down>"] = {
			{
				function()
					local L = require("move-line")
					local count = vim.v.count1
					L.moveLine(count, "down")
					R.Record(function()
						L.moveLine(count, "down")
					end)
				end,
				{ "n" },
			},
			{
				function()
					local L = require("move-line")
					local count = vim.v.count1
					L.moveLineVisualMode(count, "down")
					R.Record(function()
						L.moveLineVisualMode(count, "down")
					end)
				end,
				{ "x" },
			},
		},
		-- move line(s): Up
		["<C-up>"] = {
			{
				function()
					local L = require("move-line")
					local count = vim.v.count1
					L.moveLine(count, "up")
					R.Record(function()
						L.moveLine(count, "up")
					end)
				end,
				{ "n" },
			},
			{
				function()
					local L = require("move-line")
					local count = vim.v.count1
					L.moveLineVisualMode(count, "up")
					R.Record(function()
						L.moveLineVisualMode(count, "up")
					end)
				end,
				{ "x" },
			},
		},

		--???????
		["<C-[>"] = { "<C-O>", "n" },
		-- ["e"] = { "a", { "n" } },
		-- ["w"] = { "i", { "n" } },
		["e"] = {
			function()
				base.rightEnterInsertMode()
			end,
			"n",
			{ desc = "right enter insert mode" },
		},
		["w"] = {
			function()
				base.leftEnterInsertMode()
			end,
			"n",
			{ desc = "left enter insert mode" },
		},
		["E"] = { "A", { "n", "x" } },
		["W"] = { "I", { "n", "x" } },
		["<space><space>w"] = { "0i", { "n" } },
		["<space><space>e"] = { "$a", { "n" } },

		-- quit insert mode quickly
		["jk"] = {
			{ "<Esc>", { "i" } },
			{ "<C-u><ESC>", { "c" } },
		},
		["jj"] = {
			{ "<Esc>", { "i" } },
			{ "<C-u><ESC>", { "c" } },
		},
		["kj"] = {
			{ "<Esc>", { "i" } },
			{ "<C-u><ESC>", { "c" } },
		},
		["kk"] = {
			{ "<Esc>", { "i" } },
			{ "<C-u><ESC>", { "c" } },
		},
		[";;"] = {
			{ "<Esc>", { "i" } },
			{ "<C-u><ESC>", { "c" } },
		},
		["；；"] = {
			{ "<Esc>", { "i" } },
			{ "<C-u><ESC>", { "c" } },
		},

		["Y"] = { "y$", { "n" } },
		["Q"] = {
			{ "gwap", { "n" } },
			{ "gw", { "x" } },
		},
		-- yank/paste/del A register text
		["<space>y"] = { '"ay', { "n", "x" } },
		["<space>p"] = { '"ap', { "n", "x" } },
		["<space>P"] = { '"aP', { "n" } },
		["<space>d"] = { '"ad', { "n", "x" } },

		-- yank/paste/del Outer register text
		["<space><space>y"] = { '"+y', { "n", "x" } },
		["<space><space>p"] = { '"+p', { "n", "x" } },
		["<space><space>P"] = { '"+P', { "n", "x" } },
		["<space><space>d"] = { '"+d', { "n", "x" } },

		-- goto last cursor position
		["<space>["] = { "<C-o>", "n" },
		-- goto tag in cursor text
		["<space>]"] = { "<C-]>", "n" },

		["<C-F11>"] = { "<C-v>", { "i" } },
		-- del cursor left all text
		["<C-u>"] = { "<C-G>u<C-u>", { "i" } },
		-- del cursor right all text
		["<M-u>"] = { "<C-o>d$", { "i" } },

		-- del cursor left all text(without space)
		["<C-space><C-u>"] = { "<C-o>d^", { "i" } },
		-- del cursor right all text(without space)
		["<M-space><M-u>"] = { "<C-o>v$ged", { "i" } },
		--??????? cannot listen this key combination
		["<C-BS>"] = { "<Left><C-o>diw", { "i" } },
		-- ["<C-BS>"] = {
		-- function()
		-- print("nihao")
		-- end,
		-- { "i" },
		-- },
		-- del left single letter (The opposite of BS)
		["<M-BS>"] = { "<Del>", { "i" } },
		-- Delete the text where the cursor is located
		["<M-Del>"] = { "<C-o>diw", { "i" } },

		--???? 非粘贴模式
		["<M-p>"] = {
			{ '<C-G>u<C-R>"', { "i" } },
			{ "<C-W>p", "n" },
		},
		["<M-S-p>"] = {
			"<C-w>P",
			"n",
		},

		-- 粘贴模式
		["<C-v>"] = {
			{ '<C-G>u<C-R>"', { "i" } },
			{ '<C-R>"', { "c" }, { silent = false } },
			{ "<C-\\><C-N>pi", "t" },
		},

		--map('c', '<C-v>', '<C-R>\'', Opts)
		["<M-space><M-p>"] = {
			{ "<C-G>u<C-R><C-o>a", { "i" } },
			{ "<C-R>a", { "c" }, { silent = false } },
		},

		-- Map('c', '<C-space><C-v>', '<C-G>u<C-R><C-o>a', Opts)
		["<M-space><M-v>"] = { "<C-G>u<C-R>'", { "i" } },

		-- 粘贴模式
		["<M-space><M-space><M-p>"] = {
			{ "<C-G>u<C-R><C-O>+", { "i" } },
			{ "<C-R>+", "c", { silent = false } },
		},

		--map('c', '<C-space><C-space><C-v>', '<C-G>u<C-R><C-o>*', Opts)
		-- 非粘贴模式
		["<M-space><M-space><M-v>"] = { "<C-G>u<C-R>*", { "i" } },

		["b"] = { "o", { "n", "x" } },
		["B"] = { "O", { "n", "x" } },

		["<M-->"] = { "J", "x" },

		--????
		["<space>r"] = { "gR", "n" },
		--["<space><CR>"] = {'i<CR><Esc>l', 'n'},
		--???
		["<space>u"] = { "U", "n" },
		["U"] = { "<C-R>", "n" },
		--???
		["<C-.>"] = { "<C-T>", "i" },
		--???
		["<C-,>"] = { "<C-D>", "i" },
		["<C-space><C-,>"] = { "0<C-D>", "i" },
		["<C-space><C-.>"] = { "^<C-D>", "i" },

		-- insert mode: save file
		["<C-S>"] = { "<C-O>:w<CR>", "i" },
		-- insert mode use d operator
		["<M-d><M-i>"] = { "<C-O>db", "i" },
		["<M-d><M-o>"] = { "<C-O>de", "i" },
		["<M-d><M-S-i>"] = { "<C-O>dB", "i" },
		["<M-d><M-S-o>"] = { "<C-O>dE", "i" },
		["<M-d><M-space><M-i>"] = { "<C-O>dge", "i" },
		["<M-d><M-space><M-o>"] = { "<C-O>dw", "i" },
		["<M-d><M-space><M-S-i>"] = { "<C-O>dgE", "i" },
		["<M-d><M-space><M-S-o>"] = { "<C-O>dW", "i" },
		["<M-d><M-space><M-h>"] = { "<C-O>d^", "i" },
		["<M-d><M-space><M-l>"] = { "<C-O>dg_", "i" },
		["<M-d><M-space><M-space><M-h>"] = { "<C-O>d0", "i" },
		["<M-d><M-space><M-space><M-l>"] = { "<C-O>d$", "i" },
		["<M-d><M-d>"] = { "<C-o>dd", "i" },
		["<M-d><M-S-G>"] = { "<C-o>dG", "i" },
		["<M-d><M-g><M-g>"] = { "<C-o>dgg", "i" },

		-- insert mode use gg/G
		["<M-S-g>"] = { "<C-o>G", "i" },
		["<M-g><M-g>"] = { "<C-o>gg", "i" },

		-- resize window
		["<M-down>"] = { ":resize +3<CR>", { "n" } },
		["<M-up>"] = { ":resize -3<CR>", { "n" } },
		["<M-right>"] = { ":vertical resize -3<CR>", { "n" } },
		["<M-left>"] = { ":vertical resize +3<CR>", { "n" }, { silent = true } },

		["<S-ScrollWheelDown>"] = {
			{ "zs", { "n" } },
			{ "<C-o>zs", { "i" } },
		},
		["<S-ScrollWheelUp>"] = {
			{ "ze", { "n" } },
			{ "<C-o>ze", { "i" } },
		},
		["<M-ScrollWheelDown>"] = {
			{ ":vertical resize +5<CR>", "n" },
			{ "<C-o>:vertical resize +5<CR>", "i" },
		},

		["<M-ScrollWheelUp>"] = {
			{ ":vertical resize -5<CR>", "n" },
			{ "<C-o>:vertical resize -5<CR>", "i" },
		},

		["<space>="] = { "<C-W>=", "n" },
		["<space>-"] = { "<C-W>|<C-W>_^", "n" },
		["<space><space>-"] = {
			function()
				require("switch-function").switch("wrap")
			end,
			{ "n" },
		},

		-- 上下移动视图
		["<C-j>"] = {
			{ "<C-y><C-y>", { "n", "x" } },
			{ "<C-O>2<C-y>", { "i" } },
		},
		["<C-k>"] = {
			{ "<C-e><C-e>", { "n", "x" } },
			{ "<C-O>2<C-e>", { "i" } },
		},
		["<C-h>"] = {
			{ "6zh", { "n", "x" } },
			{ "<C-O>6zh", "i" },
		},
		["<C-l>"] = {
			{ "6zl", { "n", "x" } },
			{ "<C-O>6zl", "i" },
		},
		-- 上下左右翻页
		-- // Alacritty 不工作
		["<C-M-j>"] = {
			{ "<C-f>M", "n" },
			{ "<C-O><C-f><C-O>M", "i" },
			{ "<C-f>4<C-y>", "x" },
		},

		-- // Alacritty 不工作
		["<C-M-k>"] = {
			{ "<C-b>M", "n" },
			{ "<C-O><C-b><C-O>M", "i" },
			{ "<C-b>4<C-e>", "x" },
		},

		-- // Alacritty 不工作
		["<C-M-l>"] = {
			function()
				local count = vim.v.count1
				base.FilpLeftAndRight("right", count)
				R.Record(function()
					base.FilpLeftAndRight("right", count)
				end)
			end,
			{ "n", "i", "x" },
		},

		-- // Alacritty 不工作
		["<C-M-h>"] = {
			function()
				local count = vim.v.count1
				base.FilpLeftAndRight("left", count)
				R.Record(function()
					base.FilpLeftAndRight("left", count)
				end)
			end,
			{ "n", "i", "x" },
		},
		-- buffer
		["<Tab>j"] = { ":bn<CR>", "n" },
		["<Tab>k"] = { ":bp<CR>", "n" },
		["<Tab>h"] = { "gT", "n" },
		["<Tab>l"] = { "gt", "n" },

		-- ["<space><Tab>"] = { "g<tab>", "n" },

		-- ["<Tab><Tab>l"] = { ":+tabmove<CR>", "n" },
		-- ["<Tab><Tab>h"] = { ":-tabmove<CR>", "n" },

		-- ["<Tab>1"] = { ":tabn 1<CR>", "n" },
		-- ["<Tab>2"] = { ":tabn 2<CR>", "n" },
		-- ["<Tab>3"] = { ":tabn 3<CR>", "n" },
		-- ["<Tab>4"] = { ":tabn 4<CR>", "n" },
		-- ["<Tab>5"] = { ":tabn 5<CR>", "n" },
		-- ["<Tab>6"] = { ":tabn 6<CR>", "n" },
		-- ["<Tab>7"] = { ":tabn 7<CR>", "n" },
		-- ["<Tab>8"] = { ":tabn 8<CR>", "n" },
		-- ["<Tab>9"] = { ":tabn 9<CR>", "n" },
		-- ["<Tab>10"] = { ":tabn 10<CR>", "n" },

		-- ["<Tab>n"] = { ":tabnew<CR>", "n" },

		["<space><space>vs"] = { ":vs<CR>", "n" },
		["<space><space>vn"] = { ":vnew<CR>", "n" },
		["<space><space>sn"] = { ":sp<CR>", "n" },

		["<space><space><space><space>v"] = { ":bro vs<CR>", "n" },

		["<tab>c"] = { ":tabclose<CR>", "n" },
		["<tab><tab>c"] = { ":tabclose!<CR>", "n" },
		["<tab>o"] = { ":on<CR>", "n" },
		["<tab>O"] = { ":tabonly<CR>", "n" },

		["<space>c"] = { ":close<CR>", "n" },
		["<space><space>c"] = { ":close!<CR>", "n" },

		["<space>q"] = { ":q<CR>", "n" },
		["<space><space>q"] = { ":q!<CR>", "n" },
		["<space><space><space>q"] = { ":qa!<CR>", "n" },
		-- vsplit current file left-right
		["<M-v>"] = {
			":vsplit<cr>",
			"n",
		},
		--? split current file top-bottom
		["<M-S-V"] = {
			":split<cr>",
			"n",
		},

		["h"] = {
			function()
				local count = vim.v.count
				base.cursorLeftMove(count, 1)
				R.Record(function()
					base.cursorLeftMove(count, 1)
				end)
			end,
			"n",
			{ desc = "left move" },
		},
		-- ["j"] = { "gj", "n" },
		["j"] = {
			function()
				local count = vim.v.count
				base.cursorDownMove(count, 1)
				R.Record(function()
					base.cursorDownMove(count, 1)
				end)
			end,
			"n",
			{ desc = "down move" },
		},
		-- ["k"] = { "gk", "n" },
		["k"] = {
			function()
				local count = vim.v.count
				base.cursorUpMove(count, 1)
				R.Record(function()
					base.cursorUpMove(count, 1)
				end)
			end,
			"n",
			{ desc = "up move" },
		},
		["l"] = {
			function()
				local count = vim.v.count
				base.cursorRightMove(count, 1)
				R.Record(function()
					base.cursorRightMove(count, 1)
				end)
			end,
			"n",
			{ desc = "right move" },
		},
		["H"] = {
			{
				function()
					local count = vim.v.count
					base.cursorLeftMove(count, 3)
					R.Record(function()
						base.cursorLeftMove(count, 3)
					end)
				end,
				"n",
				{ desc = "Left move" },
			},
			{
				"3h",
				"x",
				{ desc = "Left move" },
			},
		},
		["J"] = {
			{
				function()
					local count = vim.v.count
					base.cursorDownMove(count, 3)
					R.Record(function()
						base.cursorDownMove(count, 3)
					end)
				end,
				"n",
				{ desc = "Down move" },
			},
			{
				"3j",
				"x",
				{ desc = "Down move" },
			},
		},
		["K"] = {
			{
				function()
					local count = vim.v.count
					base.cursorUpMove(count, 3)
					R.Record(function()
						base.cursorUpMove(count, 3)
					end)
				end,
				"n",
				{ desc = "Up move" },
			},
			{
				"3k",
				"x",
				{ desc = "Up move" },
			},
		},
		["L"] = {
			{
				function()
					local count = vim.v.count
					base.cursorRightMove(count, 3)
					R.Record(function()
						base.cursorRightMove(count, 3)
					end)
				end,
				"n",
				{ desc = "Right move" },
			},
			{
				"3l",
				"x",
				{ desc = "Right move" },
			},
		},
		-- ["H"] = { "3h", { "n", "x" } },
		-- ["J"] = { "3j", { "n", "x" } },
		-- ["K"] = { "3k", { "n", "x" } },
		-- ["L"] = { "3l", { "n", "x" } },

		["<space>h"] = { "^", { "n", "x", "o" } },
		["<space>l"] = { "g_", { "n", "x", "o" } },
		["<space>j"] = { "<Down>g_", { "n", "x" } },
		["<space>k"] = { "<Up>g_", { "n", "x" } },
		["<space>m"] = { "gM", { "n", "x", "o" } },
		["<space>n"] = { "gM", { "n", "x", "o" } },
		["<M-space><M-m>"] = { "<C-o>gM", { "i" } },
		["<M-space><M-n>"] = { "<C-o>gM", { "i" } },
		["<space><space>h"] = { "0", { "n", "x", "o" } },
		["<space><space>l"] = { "$", { "n", "x", "o" } },
		["<space><space>j"] = { "+", { "n", "x", "o" } },
		["<space><space>k"] = { "-", { "n", "x", "o" } },

		["{"] = { "{zz", "n" },
		["}"] = { "}zz", "n" },

		-- normal mode cursor move: screen left
		["ah"] = { "g0", { "n", "x", "o" } },
		-- normal mode cursor move: screen right
		["al"] = { "g$", { "n", "x", "o" } },
		-- normal mode cursor move: screen bottom
		["aj"] = { "L", { "n", "x", "o" } },
		-- normal mode cursor move: screen top
		["ak"] = { "H", { "n", "x", "o" } },
		-- normal mode cursor move: screen center
		["am"] = { "gm", { "n", "x", "o" } },
		-- normal mode cursor move: screen center col
		["an"] = { "M", { "n", "x", "o" } },

		-- normal mode view move: cursor word position at screen right
		["aal"] = { "ze", { "n", "x" } },
		-- normal mode view move: cursor word position at screen left
		["aah"] = { "zs", { "n", "x" } },
		-- normal mode view move: cursor line position at screen top col
		["aak"] = { "zt", { "n", "x" } },
		-- normal mode view move: cursor line position at screen bottom col
		["aaj"] = { "zb", { "n", "x" } },
		-- normal mode view move: cursor line position at screen center col
		["aan"] = { "zz", { "n", "x" } },

		-- normal mode view move: cursor word position at screen right
		["<M-1><M-1><M-l>"] = { "<C-o>zs", { "i" } },
		-- normal mode view move: cursor word position at screen left
		["<M-1><M-1><M-h>"] = { "<C-o>ze", { "i" } },
		-- normal mode view move: cursor line position at screen top col
		["<M-1><M-1><M-k>"] = { "<C-o>zb", { "i" } },
		-- normal mode view move: cursor line position at screen bottom col
		["<M-1><M-1><M-j>"] = { "<C-o>zt", { "i" } },
		-- normal mode view move: cursor line position at screen center col
		["<M-1><M-1><M-n>"] = { "<C-o>zz", { "i" } },

		["<C-space><C-v>"] = { '<C-\\><C-N>"api', "t", { silent = false, noremap = true } },
		["<C-space><C-space><C-v>"] = { '<C-\\><C-N>"+pi', "t", { silent = false, noremap = true } },
		["<M-`><M-h>"] = { "<home>", "t" },
		["<M-`><M-l>"] = { "<end>", "t" },
		["<Esc>"] = { "<C-\\><C-N>", "t" },
		["<space>i"] = { "ge", { "n", "x", "o" } },
		["<space>I"] = { "gE", { "n", "x", "o" } },
		["<space>o"] = { "w", { "n", "x", "o" } },
		["<space>O"] = { "W", { "n", "x", "o" } },
		-- normal mode into insert mode ea
		["<space><M-i>"] = {
			{ "gea", { "n" } },
		},
		-- normal mode into insert mode Ea
		["<space><M-S-i>"] = {
			{ "gEa", { "n" } },
		},
		-- normal mode into insert mode: wi
		["<space><M-o>"] = {
			{ "wi", { "n" } },
		},
		-- normal mode into insert mode: Wi
		["<space><M-S-o>"] = {
			{ "Wi", { "n" } },
		},
		-- normal mode into insert mode: ei
		["<M-o>"] = {
			{ "<Esc>ea", { "i" } },
			{ "<S-right>", { "c" } },
			{ "ea", { "n" } },
		},
		-- normal mode into insert mode: Ei
		["<M-S-o>"] = {
			{ "<Esc>Ea", { "i" } },
			{ "Ea", { "n" } },
		},
		-- normal mode into insert mode: bi
		["<M-i>"] = {
			{ "<Esc>bi", { "i" } },
			{ "<S-left>", { "c" } },
			{ "bi", { "n" } },
		},
		-- normal mode into insert mode: Bi
		["<M-S-i>"] = {
			{ "<Esc>Bi", { "i" } },
			{ "Bi", { "n" } },
		},

		-- insert mode move: k,
		["<M-k>"] = {
			{ "<Up>", { "i", "c" }, { silent = false } },
			{ "<C-W>k^", { "n" } },
			{ "<up>", "t" },
		},
		-- insert mode move: j,
		["<M-j>"] = {
			{ "<Down>", { "i", "c" }, { silent = false } },
			{ "<C-W>j^", { "n" } },
			{ "<down>", "t" },
		},
		-- insert mode move: h,
		["<M-h>"] = {
			{ "<left>", { "i", "c" }, { silent = false } },
			{ "<C-W>h^", { "n" } },
			{ "<left>", "t" },
		},
		-- insert mode move: l,
		["<M-l>"] = {
			{ "<right>", { "i", "c" }, { silent = false } },
			{ "<C-W>l^", { "n" } },
			{ "<right>", "t" },
		},
		-- insert mode move: exclusive words like e,
		["<M-space><M-i>"] = {
			{ "<Esc>gea", { "i" } },
		},
		-- insert mode move: exclusive words like E,
		["<M-space><M-S-i>"] = {
			{ "<Esc>gEa", { "i" } },
		},
		-- insert mode move: exclusive words like w,
		["<M-space><M-o>"] = {
			{ "<S-right>", { "i" } },
		},
		-- insert mode move: exclusive words like W,
		["<M-space><M-S-o>"] = {
			{ "<Esc>Wi", { "i" } },
		},
		-- insert mode move: like H,
		["<M-S-h>"] = {
			{ "<C-o>3h", { "i" }, { silent = false } },
			{ "<left><left><left><left><left>", "t" },
		},
		-- insert mode move: like J,
		["<M-S-j>"] = {
			{ "<C-o>3j", { "i" }, { silent = false } },
			{ "<down><down><down><down><down>", "t" },
		},
		-- insert mode move: like K,
		["<M-S-k>"] = {
			{ "<C-o>3k", { "i" }, { silent = false } },
			{ "<up><up><up><up><up>", "t" },
		},
		-- insert mode move: like L,
		["<M-S-l>"] = {
			{ "<C-o>3l", { "i" }, { silent = false } },
			{ "<right><right><right><right><right>", "t" },
		},
		-- insert mode move: screen left,
		["<M-1><M-h>"] = { "<C-o>g0", { "i" } },
		-- insert mode move: screen right,
		["<M-1><M-l>"] = { "<C-o>g$", { "i" } },
		-- insert mode move: screen bottom,
		["<M-1><M-j>"] = { "<C-o>L", { "i" } },
		-- insert mode move: screen top,
		["<M-1><M-k>"] = { "<C-o>H", { "i" } },
		-- insert mode move: screen center,
		["<M-1><M-m>"] = { "<C-o>gm", { "i" } },
		-- insert mode move: screen center col,
		["<M-1><M-n>"] = { "<C-o>M", { "i" } },
		-- insert mode move: Home(ignore space),
		["<M-space><M-h>"] = {
			{ "<C-o>I", { "i" } },
			{ "<C-W>H", "n" },
		},
		-- insert mode move: Home,
		["<M-space><M-space><M-h>"] = { "<Home>", { "i", "c" }, { silent = false } },
		-- insert mode move: End,
		["<M-space><M-l>"] = {
			{ "<C-o>A", { "i" } },
			{ "<C-W>L", "n" },
		},
		-- insert mode move: End,
		["<M-space><M-space><M-l>"] = { "<End>", { "i", "c" }, { silent = false } },
		-- insert mode move: Up End,
		["<M-space><M-k>"] = {
			{ "<Up><End>", { "i" } },
			{ "<C-W>K", "n" },
		},
		-- insert mode move: Up Home,
		["<M-space><M-space><M-k>"] = { "<Up><Home>", { "i" } },
		-- insert mode move: Down End
		["<M-space><M-j>"] = {
			{ "<Down><End>", { "i" } },
			{ "<C-W>J", "n" },
		},
		-- insert mode move: Down Home,
		["<M-space><M-space><M-j>"] = { "<Down><Home>", { "i" } },

		-- repeat latest f
		["<M-f>"] = { ";", { "n" } },
		-- repeat latest F
		["<M-S-f>"] = { ",", { "n" } },
		-- add new line above current line and into insert mode
		["<space>b"] = { "o<C-u>", { "n" } },
		-- add new line below current line and into insert mode
		["<space>B"] = { "O<C-u>", { "n" } },
		-- block visual
		["<space>v"] = { "<C-v>", { "n", "x" } },
		-- normal mode into insert mode: cursor at screen left
		["aw"] = { "<Esc>g0i", { "n" } },
		-- normal mode into insert mode: cursor at screen right
		["ae"] = { "<Esc>g$i", { "n" } },

		-- gh: normal mode into select mode
		-- normal mode into select block mode
		["<space>gh"] = { "g<C-h>", { "n" } },
		-- visual mode and select mode exchange
		["gh"] = {
			{ "<C-g>", { "x" } },
			{ "<C-g>", { "s" } },
		},
		-- select mode select line
		["gH"] = { "<C-g>gH", { "s" } },
		-- select mode delete select text
		["<BS>"] = { "<C-g>s", "s" },
		["i"] = {
			{
				function()
					local count = vim.v.count
					base.normalModeWordLeftMove(count)
					R.Record(function()
						base.normalModeWordLeftMove(count)
					end)
				end,
				"n",
				{ desc = "word left move" },
			},
			{
				function()
					local count = vim.v.count1
					base.OmodeWordLeftMove(count)
					R.Record(function()
						base.OmodeWordLeftMove(count)
					end)
				end,
				"o",
				{ desc = "word left move" },
			},
			{ "b", { "x" }, { desc = "word left move" } },
		},
		["o"] = {
			{
				function()
					local count = vim.v.count
					base.normalModeWordRightMove(count)
					R.Record(function()
						base.normalModeWordRightMove(count)
					end)
				end,
				"n",
				{ desc = "word right move" },
			},
			{
				"e",
				{ "x", "o" },
				{ desc = "word right move" },
			},
		},
		["I"] = {
			{
				function()
					local count = vim.v.count
					base.normalModeWORDLeftMove(count)
					R.Record(function()
						base.normalModeWORDLeftMove(count)
					end)
				end,
				"n",
				{ desc = "WORD left move" },
			},
			{
				"B",
				{ "x", "o" },
				{ desc = "WORD left move" },
			},
		},
		["O"] = {
			{
				function()
					local count = vim.v.count
					base.normalModeWORDRightMove(count)
					R.Record(function()
						base.normalModeWORDRightMove(count)
					end)
				end,
				"n",
				{ desc = "WORD right move" },
			},
			{ "E", { "x", "o" }, { desc = "WORD right move" } },
		},

		-- textobject
		["ww"] = { "aw", { "x", "o" } },
		["ew"] = { "iw", { "x", "o" } },
		["wW"] = { "aW", { "x", "o" } },
		["eW"] = { "iW", { "x", "o" } },

		["ws"] = { "as", { "x", "o" } },
		["es"] = { "is", { "x", "o" } },
		["wp"] = { "ap", { "x", "o" } },
		["ep"] = { "ip", { "x", "o" } },

		["w["] = { "a[", { "x", "o" } },
		["e["] = { "i[", { "x", "o" } },

		["w]"] = { "a]", { "x", "o" } },
		["e]"] = { "i]", { "x", "o" } },

		["w{"] = { "a}", { "x", "o" } },
		["w}"] = { "a}", { "x", "o" } },
		["e{"] = { "i}", { "x", "o" } },
		["e}"] = { "i}", { "x", "o" } },

		["w("] = { "a)", { "x", "o" } },
		["e("] = { "i)", { "x", "o" } },

		["w)"] = { "a)", { "x", "o" } },
		["e)"] = { "i)", { "x", "o" } },

		["w>"] = { "a>", { "x", "o" } },
		["e>"] = { "i>", { "x", "o" } },
		["w<"] = { "a>", { "x", "o" } },
		["e<"] = { "i>", { "x", "o" } },

		['w"'] = { 'a"', { "x", "o" } },
		['e"'] = { 'i"', { "x", "o" } },
		["w'"] = { "a'", { "x", "o" } },
		["e'"] = { "i'", { "x", "o" } },
		["w`"] = { "a`", { "x", "o" } },
		["e`"] = { "i`", { "x", "o" } },
		["wl"] = { "^o$h", { "x" } },
	},
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)
-- vim.g.python3_host_prog = "E:/scoop/apps/python/current/python.exe"

require("globals")
require("lazy").setup("plugins")
-- vim.keymap.del("x", "ii")

-- vnoremap("<A-j>", ":m '>+1<CR>gv=gv")
-- vnoremap("<A-k>", ":m '<-2<CR>gv=gv")

-- set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })
-- set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })

-- Toggle hlsearch if it's on, otherwise just do "enter"
-- set("n", "<CR>", function()
-- if vim.v.hlsearch == 1 then
-- vim.cmd.nohl()
-- return ""
-- else
-- return k "<CR>"
-- end
-- end, { expr = true })

-- Normally these are not good mappings, but I have left/right on my thumb
-- cluster, so navigating tabs is quite easy this way.
-- set("n", "<left>", "gT")
-- set("n", "<right>", "gt")

-- There are builtin keymaps for this now, but I like that it shows
-- the float when I navigate to the error - so I override them.
-- set("n", "]d", fn(vim.diagnostic.jump, { count = 1, float = true }))
-- set("n", "[d", fn(vim.diagnostic.jump, { count = -1, float = true }))

vim.api.nvim_set_keymap(
	"n",
	"<leader>tw",
	"<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>",
	{}
)
vim.opt.signcolumn = "no"
