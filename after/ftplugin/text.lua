vim.wo[0][0].concealcursor = ""

-- 制表符显示 8 列宽度
vim.bo.tabstop = 8
-- <<>> 移动 8 列宽度
vim.bo.shiftwidth = 8
-- 以适当数量的空格来插入一个 <Tab>
vim.bo.expandtab = false
-- <Tab> 键会将光标移动到下一个软制表位，而不是插入字面制表符
vim.bo.softtabstop = 0
-- smarttab = true, -- 如果光标位于前导空白中，<Tab> 键将缩进 'shiftwidth' 距离。<BS> 键具有相反的效果

vim.bo.formatoptions = "tcqj"

vim.wo[0][0].colorcolumn = "78"
vim.wo[0][0].spell = false
