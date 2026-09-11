--- @param cmdwintype string
local function toggle_cmdwin(cmdwintype)
  local tabpages = vim.api.nvim_list_tabpages()
  local cmdwin
  for i = 1, #tabpages do
    local tabpage = tabpages[i]
    local wins = vim.api.nvim_tabpage_list_wins(tabpage)
    for _, win in ipairs(wins) do
      local type = vim.fn.win_gettype(win)
      if type == "command" then
        cmdwin = win
        break
      end
    end
  end
  if cmdwin then
    local current_cmdwintype = vim.fn.getcmdwintype()
    vim.api.nvim_win_close(cmdwin, true)
    if current_cmdwintype ~= cmdwintype then
      vim.api.nvim_feedkeys("q" .. cmdwintype, "ni", false)
    end
  else
    vim.api.nvim_feedkeys("q" .. cmdwintype, "ni", false)
  end
end

return {
  ["q:"] = {
    function()
      toggle_cmdwin(":")
    end,
    { "n", "x" },
    exclude_ft = { "pager" },
    desc = "[q:]Toggle the command-line window",
  },
  ["q/"] = {
    function()
      toggle_cmdwin("/")
    end,
    { "n", "x" },
    exclude_ft = { "pager" },
    desc = "[q/]Toggle the command-line window",
  },
  ["q?"] = {
    function()
      toggle_cmdwin("?")
    end,
    { "n", "x" },
    exclude_ft = { "pager" },
    desc = "[q/]Toggle the command-line window",
  },
}
