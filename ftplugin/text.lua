require("neo-option").setlocal({
  concealcursor = {},
  spell = false,
  formatoptions = { ["t"] = true, ["c"] = true, ["j"] = true, ["q"] = true },

  -- just default
  tabstop = 8, -- 制表符显示 8 列宽度
  shiftwidth = 8, -- <<>> 移动 8 列宽度
  expandtab = false, -- 以适当数量的空格来插入一个 <Tab>
  softtabstop = 0, -- <Tab> 键会将光标移动到下一个软制表位，而不是插入字面制表符
  smarttab = true, -- 如果光标位于前导空白中，<Tab> 键将缩进 'shiftwidth' 距离。<BS> 键具有相反的效果
})
