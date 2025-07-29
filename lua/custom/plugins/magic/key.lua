local M = {}
local KEYS = "abcdefghijklmnopqrstuvwxyz"
local key_types = { "one_key", "two_key", "three_key" }

local function get_random_key(is_ok)
	local random = math.random(26)
	local key = KEYS:sub(random, random)

	if not is_ok(key) then
		return get_random_key(is_ok)
	end

	return key
end

function M:clean()
	for key, value in pairs(self) do
		if type(value) ~= "function" then
			self[key] = nil
		end
	end
end

function M:init()
	self.ns_ids = {}
	self.on_keys = nil
	self.one_key = {
		available_key_count = 0,
		used_key_count = 0,
		keys = {},
		ns_id = nil,
	}

	self.two_key = {
		available_key_count = 0,
		used_key_count = 0,
		keys = {},
	}

	self.three_key = {
		available_key_count = 0,
		used_key_count = 0,
		keys = {},
	}
end

function M:compute_key(total)
	local function run(i)
		local min = math.pow(26, i)
		local max = math.pow(26, i + 1)

		if total >= min and total <= max then
			local remain = total - min
			local quotient = math.floor(remain / min)
			local remainder = remain - (quotient * min)
			local more_keys = math.ceil((remainder + quotient) / min) + quotient
			return {
				[key_types[i]] = 26 - more_keys,
				[key_types[i + 1]] = more_keys,
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

	local result = run(1)

	if result.one_key ~= nil then
		self.one_key.available_key_count = result.one_key
		self.one_key.ns_id = self:create_ns_id("custom-delete-word-one-key")
	end
	if result.two_key ~= nil then
		self.two_key.available_key_count = result.two_key
	end
	if result.three_key ~= nil then
		self.three_key.available_key_count = result.three_key
	end
end

function M:process_one_key(line, start_col, end_col, callback)
	local key = get_random_key(function(key)
		return self.one_key.keys[key] == nil
	end)
	self.one_key.keys[key] = {
		key = key,
		callback = function()
			self:clear_ns_id()
			callback()
		end,
	}
	self.one_key.used_key_count = self.one_key.used_key_count + 1

	vim.api.nvim_buf_set_extmark(0, self.one_key.ns_id, line, start_col, {
		virt_text_pos = "overlay",
		virt_text = { { key, "CustomMagicNextKey" } },
	})
	vim.api.nvim_buf_set_extmark(0, self.one_key.ns_id, line, start_col, {
		end_col = end_col,
		hl_group = "Visual",
	})
end

function M:process_two_key(line, start_col, end_col, callback)
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
		M:process_two_key(line, start_col, end_col)
	else
		local current = self.two_key.current

		if current.used_key_count == current.available_key_count then
			self.two_key.current = nil
			M:process_two_key(line, start_col, end_col)
			return
		end

		local key = get_random_key(function(key)
			return current.keys[key] == nil
		end)
		current.keys[key] = {
			key = key,
			callback = function()
				self:clear_ns_id()
				callback()
			end,
			reset_mark = function()
				vim.api.nvim_buf_set_extmark(0, current.child_ns_id, line, start_col, {
					virt_text_pos = "overlay",
					virt_text = { { key, "CustomMagicNextKey" } },
				})
				vim.api.nvim_buf_set_extmark(0, current.child_ns_id, line, start_col, {
					end_col = end_col,
					hl_group = "Visual",
				})
			end,
		}
		current.used_key_count = current.used_key_count + 1

		vim.api.nvim_buf_set_extmark(0, current.ns_id, line, start_col, {
			virt_text_pos = "overlay",
			virt_text = { { current.key, "CustomMagicNextKey1" } },
		})

		if end_col - start_col ~= 1 then
			vim.api.nvim_buf_set_extmark(0, current.child_ns_id, line, start_col + 1, {
				virt_text_pos = "overlay",
				virt_text = { { key, "CustomMagicNextKey2" } },
			})
		end

		vim.api.nvim_buf_set_extmark(0, current.child_ns_id, line, start_col, {
			end_col = end_col,
			hl_group = "Visual",
		})
	end
end

function M:process_three_key(line, start_col, end_col) end

function M:register(line, start_col, end_col, callback)
	if self.one_key.used_key_count < self.one_key.available_key_count then
		self:process_one_key(line, start_col, end_col, callback)
		return
	end

	if self.two_key.used_key_count < self.two_key.available_key_count then
		self:process_two_key(line, start_col, end_col, callback)
		return
	end

	if self.three_key.used_key_count < self.three_key.available_key_count then
		self:process_three_key(line, start_col, end_col)
		return
	end
end

function M:on_key(callback)
	vim.schedule(function()
		local char = vim.fn.nr2char(vim.fn.getchar())
		if self.on_keys[char] == nil then
			self:clear_ns_id()
			callback()
			return
		end
		self.on_keys[char].callback()
	end)
end

function M:ready_on_key(callback)
	self.on_keys = vim.tbl_extend("force", {}, self.one_key.keys, self.two_key.keys, self.three_key.keys)
	self:on_key(callback)
end

function M:create_ns_id(name)
	local ns_id = vim.api.nvim_create_namespace(name)
	table.insert(self.ns_ids, ns_id)
	return ns_id
end

function M:clear_ns_id(opts)
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
