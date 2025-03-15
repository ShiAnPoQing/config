local M = {}

local function setKeymap(keymap)
	local ok, v = pcall(function(mode, lhs, rhs, opts)
		vim.keymap.set(mode, lhs, rhs, opts)
	end, keymap.mode, keymap.lhs, keymap.rhs, keymap.opts)

	if not ok then
		vim.api.nvim_err_writeln("keymap 格式设置有误！")
	end
end

local function parseMode3(config)
	local rhs = config.rhs
	local opts = config.opts
	local lhs = config.lhs
	local modes = config.mode

	for _, mode in pairs(modes[1]) do
		setKeymap({
			rhs = rhs,
			lhs = lhs,
			mode = mode,
			opts = vim.vim.tbl_deep_extend("force", {}, opts or {}, modes[2] or {}),
		})
	end
end

local function parseMode2(config)
	local rhs = config.rhs
	local lhs = config.lhs
	local opts = config.opts
	local modes = config.modes

	if type(modes[1]) == "table" then
		parseMode3({
			lhs = lhs,
			rhs = rhs,
			opts = opts,
			modes = modes,
		})
		return
	end

	setKeymap({
		lhs = lhs,
		rhs = rhs,
		mode = modes[1],
		opts = vim.tbl_deep_extend("force", {}, opts or {}, modes[2] or {}),
	})
end

local function parseMode1(config)
	local lhs = config.lhs
	local rhs = config.rhs
	local opts = config.opts
	local modes = config.modes

	for _, mode in pairs(modes) do
		if type(mode) == "table" then
			parseMode2({
				lhs = lhs,
				rhs = rhs,
				opts = opts,
				modes = mode,
			})
		else
			setKeymap({
				lhs = lhs,
				rhs = rhs,
				mode = mode,
				opts = opts,
			})
		end
	end
end

local function isMoreRhs(rhs)
	if type(rhs) == "table" then
		return true
	end

	return false
end

local function isMoreMode(mode)
	if type(mode) ~= "table" then
		return false
	end

	return true
end

local function parseRhs(lhs, config)
	for _, value in pairs(config) do
		local rhs = value[1]
		local mode = value[2]
		local opts = value[3]

		if isMoreRhs(rhs) then
			parseRhs({
				lhs = lhs,
				config = value,
			})
		elseif isMoreMode(mode) then
			parseMode1({
				rhs = rhs,
				lhs = lhs,
				modes = mode,
				opts = opts,
			})
		else
			setKeymap({
				lhs = lhs,
				rhs = rhs,
				mode = mode,
				opts = opts,
			})
		end
	end
end

-- 1: [lhs] = {rhs, mode, opts},
-- 2: [lhs] = {rhs, {mode1, mode2}, opts},
-- 3: [lhs] = {rhs, {mode1, {mode2, opts}}, opts}
-- 4: [lhs] = {rhs, {mode1, {mode2, opts}, {{mode3, mode4}, opts}, opts}, opts}
-- 5: [lhs] = {
--    {rhs, mode, opts},
--    {rhs, mode, opts}
-- }
-- 6,7,8,9.. same as 1, 2, 3, 4
function M.addKeymap(config)
	for lhs, value in pairs(config) do
		local rhs = value[1]
		local mode = value[2]
		local opts = value[3]

		if isMoreRhs(rhs) then
			parseRhs(lhs, value)
		elseif isMoreMode(mode) then
			parseMode1({
				rhs = rhs,
				lhs = lhs,
				modes = mode,
				opts = opts,
			})
		else
			setKeymap({
				lhs = lhs,
				rhs = rhs,
				mode = mode,
				opts = opts,
			})
		end
	end
end

function M.delKeymap(config) end

function M.setup(config)
	if type(config) ~= "table" then
		return
	end

	for key, value in pairs(config) do
		if key == "add" then
			M.addKeymap(value)
			return
		end

		if key == "del" then
			M.delKeymap(value)
			return
		end
	end
end

return M
