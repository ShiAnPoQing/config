local function tabpage_move_right()
  local tabpage = vim.api.nvim_get_current_tabpage()
  local tabs = vim.api.nvim_list_tabpages()

  if tabpage ~= tabs[#tabs] then
    vim.cmd("tabm +1")
  end
end

local function tabpage_move_left()
  local tabpage = vim.api.nvim_get_current_tabpage()
  local tabs = vim.api.nvim_list_tabpages()

  if tabpage ~= tabs[1] then
    vim.cmd("tabm -1")
  end
end

--- @param total integer
--- @param count integer
--- @return integer
local function get_absolute_tabpage_number(total, count)
  local function run()
    if count > 0 then
      if count <= total then
        return count
      end
      count = count - total
    else
      count = count + total
    end
    return run()
  end
  return run()
end

--- @param dir "left" | "right"
local function tabpage_goto(dir)
  local count = vim.v.count1
  local current = vim.api.nvim_get_current_tabpage()
  local current_number = vim.api.nvim_tabpage_get_number(current)
  local tabs = vim.api.nvim_list_tabpages()
  local number = get_absolute_tabpage_number(#tabs, dir == "left" and current_number - count or current_number + count)
  vim.api.nvim_exec2("tabn " .. number, {})
end

return {
  ["<tab>c"] = { "<cmd>tabclose<cr>", "n" },
  ["<tab><tab>c"] = { "<cmd>tabclose!<cr>", "n" },
  ["<tab>o"] = { "<cmd>on<cr>", "n" },
  ["<tab>O"] = { "<cmd>tabonly<cr>", "n" },
  ["<tab>n"] = { "<cmd>tabnew<cr>", "n" },
  ["<tab><S-l>"] = { tabpage_move_right, "n" },
  ["<tab><S-h>"] = { tabpage_move_left, "n" },
  -- gT
  ["<Tab>h"] = {
    function()
      tabpage_goto("left")
    end,
    "n",
  },
  -- gt
  ["<Tab>l"] = {
    function()
      tabpage_goto("right")
    end,
    "n",
  },
  ["<tab>p"] = {
    "g<tab>",
    "n",
  },
  ["<tab>1"] = { "<cmd>1tabnext<cr>", "n" },
  ["<tab>2"] = { "<cmd>2tabnext<cr>", "n" },
  ["<tab>3"] = { "<cmd>3tabnext<cr>", "n" },
  ["<tab>4"] = { "<cmd>4tabnext<cr>", "n" },
  ["<tab>5"] = { "<cmd>5tabnext<cr>", "n" },
  ["<tab>6"] = { "<cmd>6tabnext<cr>", "n" },
  ["<tab>7"] = { "<cmd>7tabnext<cr>", "n" },
  ["<tab>8"] = { "<cmd>8tabnext<cr>", "n" },
  ["<tab>9"] = { "<cmd>9tabnext<cr>", "n" },
  ["<tab><space>h"] = { "<cmd>tabfirst<cr>", "n" },
  ["<tab><space>l"] = { "<cmd>tablast<cr>", "n" },
}
