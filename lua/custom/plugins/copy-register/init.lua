local M = {}

local registers = {
	'"', -- 未命名寄存器
	"0",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9", -- 数字寄存器
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z", -- 命名寄存器
	"-", -- 小删除寄存器
	"*",
	"+", -- 系统剪贴板寄存器
	"/", -- 搜索寄存器
	":", -- 命令行寄存器
	"%",
	"#", -- 当前和上一个文件名
	"=", -- 表达式寄存器
}

function M.copy_register(operator)
	local char = vim.fn.nr2char(vim.fn.getchar())
	if not vim.tbl_contains(registers, char) then
		return
	end
	vim.schedule(function()
		vim.api.nvim_feedkeys('"' .. char .. operator, "n", false)
	end)
end

return M
