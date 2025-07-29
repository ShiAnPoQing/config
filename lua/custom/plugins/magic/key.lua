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

--- @class KeySetExtmarkOpts
--- @field ns_id number
--- @field key string

--- @class OneKeyRegisterOpts
--- @field set_extmark fun(opts: KeySetExtmarkOpts)

--- @class TwoKeyRegisterOpts
--- @field set_extmark fun(opts1: KeySetExtmarkOpts, opts2: KeySetExtmarkOpts)
--- @field reset_extmark fun(opts: KeySetExtmarkOpts)

--- @class KeyRegisterOpts
--- @field one_key OneKeyRegisterOpts
--- @field two_key TwoKeyRegisterOpts
--- @field callback fun()

--- @param opts KeyRegisterOpts
function M:register(opts)
	if self.one_key.used_key_count < self.one_key.available_key_count then
		self:register_one_key(opts.one_key, opts.callback)
		return
	end

	if self.two_key.used_key_count < self.two_key.available_key_count then
		self:register_two_key(opts.two_key, opts.callback)
		return
	end

	if self.three_key.used_key_count < self.three_key.available_key_count then
		self:register_three_key()
		return
	end
end

--- @param opts OneKeyRegisterOpts
function M:register_one_key(opts, callback)
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
	opts.set_extmark({ ns_id = self.one_key.ns_id, key = key })
end

--- @param opts TwoKeyRegisterOpts
function M:register_two_key(opts, callback)
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
		M:register_two_key(opts, callback)
	else
		local current = self.two_key.current

		if current.used_key_count == current.available_key_count then
			self.two_key.current = nil
			M:register_two_key(opts, callback)
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
				opts.reset_extmark({ ns_id = current.child_ns_id, key = key })
			end,
		}
		current.used_key_count = current.used_key_count + 1
		opts.set_extmark({ ns_id = current.ns_id, key = current.key }, { ns_id = current.child_ns_id, key = key })
	end
end

function M:register_three_key(opts) end

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

function M:clean()
	for key, value in pairs(self) do
		if type(value) ~= "function" then
			self[key] = nil
		end
	end
end

return M
