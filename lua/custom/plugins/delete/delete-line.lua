local M = {}

local Key = {}
local Keyword = {}
local KEYS = "abcdefghijklmnopqrstuvwxyz"

local function clean()
	for key, value in pairs(Key) do
		if type(value) ~= "function" then
			Key[key] = nil
		end
	end
	for key, value in pairs(Keyword) do
		if type(value) ~= "function" then
			Keyword[key] = nil
		end
	end
end

local function get_random_key(is_ok)
	local random = math.random(26)
	local key = KEYS:sub(random, random)

	if not is_ok(key) then
		return get_random_key(is_ok)
	end

	return key
end

local a = { "one_key", "two_key", "three_key" }

local function compute_key(total)
	local function run(i)
		local min = math.pow(26, i)
		local max = math.pow(26, i + 1)

		if total >= min and total <= max then
			local remain = total - min
			local quotient = math.floor(remain / min)
			local remainder = remain - (quotient * min)
			local more_keys = math.ceil((remainder + quotient) / min) + quotient
			return {
				[a[i]] = 26 - more_keys,
				[a[i + 1]] = more_keys,
			}
		elseif total > max then
			return run(i + 1)
		elseif total < min then
			return {
				one_key = total,
				two_key = 0,
			}
		end
	end

	return run(1)
end

function Keyword:init(opt)
	self.keyword_count = 0
	self.matches = {}
	self.keyword_ns_id = vim.api.nvim_create_namespace("custom-keyword-highlight")
	if opt.regex_type == "word" then
		self.regex = vim.regex("\\k\\+")
	elseif opt.regex_type == "WORD" then
		self.regex = vim.regex("\\k\\+\\s\\+")
	else
		self.regex = vim.regex("")
	end
	self.cursor_row = opt.cursor[1]
	self.topline = opt.topline
	self.botline = opt.botline
	self.leftcol = opt.leftcol
	self.rightcol = opt.rightcol
	self.up_break = nil
	self.down_break = nil
end

function Keyword:set_keyword_hl(row, start_col, end_col)
	local bufnr = vim.api.nvim_get_current_buf()
	vim.hl.range(bufnr, self.keyword_ns_id, "Visual", { row, start_col }, { row, end_col })
end

function Keyword:clean_keyword_hl()
	vim.api.nvim_buf_clear_namespace(0, self.keyword_ns_id, 0, -1)
end

function Keyword:_set_keyword_hl(row, start_col, end_col)
	vim.api.nvim_buf_set_extmark(0, self.keyword_ns_id, row, start_col, {
		virt_text_pos = "overlay",
		virt_text = { { "?", "CurSearch" } },
	})
end

function Keyword:del_keyword_hl()
	vim.api.nvim_buf_clear_namespace(0, self.keyword_ns_id, 0, -1)
end

function Keyword:collect_keyword(i, keyword_start, keyword_end)
	self.keyword_count = self.keyword_count + 1
	table.insert(self.matches[#self.matches], {
		keyword_end = keyword_end,
		keyword_start = keyword_start,
	})
end

function Keyword:set_keyword_target(callback)
	local count = 0
	while true do
		if self.up_break and self.down_break then
			break
		end

		if self.cursor_row - count > self.topline then
			local match = self.matches[self.cursor_row - count - self.topline]
			for index, value in ipairs(match) do
				callback(self.cursor_row - count - 2, value.keyword_start, value.keyword_end)
			end
		else
			self.up_break = true
		end

		if self.cursor_row + count <= self.botline then
			local match = self.matches[self.cursor_row + count - self.topline + 1]
			for index, value in ipairs(match) do
				callback(self.cursor_row + count - 1, value.keyword_start, value.keyword_end)
			end
		else
			self.down_break = true
		end

		count = count + 1
	end
end

function Key:init(opts)
	self.ns_ids = {}
	self.one_key = {
		available_key_count = opts.one_key,
		used_key_count = 0,
		keys = {},
		ns_id = self:create_ns_id("custom-delete-word-one-key"),
	}

	self.two_key = {
		available_key_count = opts.two_key,
		used_key_count = 0,
		keys = {},
	}

	self.three_key = {
		available_key_count = opts.three_key,
		used_key_count = 0,
		keys = {},
	}
end

function Key:process_one_key(line, start_col, end_col)
	local key = get_random_key(function(key)
		return self.one_key.keys[key] == nil
	end)
	self.one_key.keys[key] = {
		line = line,
		start_col = start_col,
		end_col = end_col,
		key = key,
		callback = function()
			self:clear_ns_id()
			Keyword:clean_keyword_hl()
			vim.api.nvim_buf_set_text(0, line, start_col, line, end_col, {})
			clean()
		end,
	}
	self.one_key.used_key_count = self.one_key.used_key_count + 1

	vim.api.nvim_buf_set_extmark(0, self.one_key.ns_id, line, start_col, {
		virt_text_pos = "overlay",
		virt_text = { { key, "MyNextKey" } },
	})
end

function Key:process_two_key(line, start_col, end_col)
	if self.two_key.current == nil then
		local key = get_random_key(function(key)
			return self.two_key.keys[key] == nil and self.one_key.keys[key] == nil
		end)

		local current = {
			available_key_count = 26,
			used_key_count = 0,
			keys = {},
			key = key,
			ns_id = self:create_ns_id("custom-delete-word-two-key-" .. key),
			child_ns_id = self:create_ns_id("custom-delete-word-two-key-" .. key .. "-child"),
		}
		current.callback = function()
			self.on_keys = current.keys
			self:clear_ns_id()
			for _, child in pairs(current.keys) do
				child.reset_mark()
			end
			vim.cmd.redraw()
			self:on_key()
		end

		self.two_key.keys[key] = current
		self.two_key.current = current
		Key:process_two_key(line, start_col, end_col)
	else
		local current = self.two_key.current

		if current.used_key_count == current.available_key_count then
			self.two_key.current = nil
			Key:process_two_key(line, start_col, end_col)
			return
		end

		local key = get_random_key(function(key)
			return current.keys[key] == nil
		end)
		current.keys[key] = {
			line = line,
			start_col = start_col,
			end_col = end_col,
			key = key,
			callback = function()
				self:clear_ns_id()
				Keyword:clean_keyword_hl()
				vim.api.nvim_buf_set_text(0, line, start_col, line, end_col, {})
				clean()
			end,
			reset_mark = function()
				vim.api.nvim_buf_set_extmark(0, current.child_ns_id, line, start_col, {
					virt_text_pos = "overlay",
					virt_text = { { key, "MyNextKey" } },
				})
			end,
		}
		current.used_key_count = current.used_key_count + 1
		if end_col - start_col == 1 then
			vim.api.nvim_buf_set_extmark(0, current.ns_id, line, start_col, {
				virt_text_pos = "overlay",
				virt_text = { { current.key, "MyNextKey1" } },
			})
		else
			vim.api.nvim_buf_set_extmark(0, current.ns_id, line, start_col, {
				virt_text_pos = "overlay",
				virt_text = { { current.key, "MyNextKey1" } },
			})
			vim.api.nvim_buf_set_extmark(0, current.child_ns_id, line, start_col + 1, {
				virt_text_pos = "overlay",
				virt_text = { { key, "MyNextKey2" } },
			})
		end
	end
end

function Key:process_three_key(line, start_col, end_col) end

function Key:get(line, start_col, end_col)
	if self.one_key.used_key_count < self.one_key.available_key_count then
		self:process_one_key(line, start_col, end_col)
		return
	end

	if self.two_key.used_key_count < self.two_key.available_key_count then
		self:process_two_key(line, start_col, end_col)
		return
	end

	if self.three_key.used_key_count < self.three_key.available_key_count then
		self:process_three_key(line, start_col, end_col)
		return
	end
end

function Keyword:get_keyword(i, leftcol, rightcol)
	table.insert(self.matches, {})
	local start_pos = 0
	while true do
		local start, end_ = self.regex:match_line(0, i - 1, start_pos)
		if not start then
			break
		end

		local keyword_start = start + start_pos
		local keyword_end = end_ + start_pos
		if keyword_start < leftcol or keyword_end > rightcol then
			return
		end
		self:collect_keyword(i, keyword_start, keyword_end)
		self:set_keyword_hl(i - 1, keyword_start, keyword_end)
		start_pos = start_pos + end_
	end
end

function Keyword:match_keyword()
	for i = self.topline, self.botline do
		Keyword:get_keyword(i, self.leftcol, self.rightcol)
	end
end

function M.magic_delete_word(opts)
	local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
	local topline = wininfo.topline
	local botline = wininfo.botline
	local leftcol = wininfo.leftcol
	local rightcol = leftcol + wininfo.width - wininfo.textoff
	local cursor = vim.api.nvim_win_get_cursor(0)

	local visual_hl = vim.api.nvim_get_hl(0, { name = "Visual" })
	vim.api.nvim_set_hl(0, "MyNextKey", {
		fg = "#ff007c",
		bg = visual_hl.bg,
	})
	vim.api.nvim_set_hl(0, "MyNextKey1", {
		fg = "#00dfff",
		bg = visual_hl.bg,
	})
	vim.api.nvim_set_hl(0, "MyNextKey2", {
		fg = "#2b8db3",
		bg = visual_hl.bg,
	})

	Keyword:init({
		cursor = cursor,
		topline = topline,
		botline = botline,
		leftcol = leftcol,
		rightcol = rightcol,
		regex_type = opts.keyword,
	})

	Keyword:match_keyword()
	Key:init(compute_key(Keyword.keyword_count))
	Keyword:set_keyword_target(function(line, start_col, end_col)
		Key:get(line, start_col, end_col)
	end)
	Key.on_keys = vim.tbl_extend("force", {}, Key.one_key.keys, Key.two_key.keys, Key.three_key.keys)
	Key:on_key()
end

function Key:on_key()
	vim.schedule(function()
		local char = vim.fn.nr2char(vim.fn.getchar())
		if self.on_keys[char] == nil then
			self:clear_ns_id()
			Keyword:clean_keyword_hl()
			return
		end
		self.on_keys[char].callback()
	end)
end

function Key:create_ns_id(name)
	local ns_id = vim.api.nvim_create_namespace(name)
	table.insert(self.ns_ids, ns_id)
	return ns_id
end

function Key:clear_ns_id(opts)
	opts = opts or {}

	if opts.filter_id == nil then
		for _, ns_id in ipairs(self.ns_ids) do
			vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
		end
		return
	end

	for _, ns_id in ipairs(self.ns_ids) do
		if ns_id ~= opts.filter_id then
			vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
		end
	end
end

return M
