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
  ["<tab>n"] = {
    function()
      vim.ui.input({
        prompt = "New Tab Edit: ",
        completion = "file",
        -- highlight = function(input) end,
      }, function(input)
        if not input then
          return
        end
        local count = vim.v.count1
        vim.cmd(count .. "tabnew " .. input)
      end)
    end,
    "n",
  },
  -- gT
  ["<Tab>h"] = {
    function()
      tabpage_goto("left")
    end,
    "n",
    desc = "Go to previous tab",
  },
  -- gt
  ["<Tab>l"] = {
    function()
      tabpage_goto("right")
    end,
    "n",
    desc = "Go to next tab",
  },
  ["<tab><tab>h"] = { "<cmd>tabfirst<cr>", "n", desc = "Go to first tab" },
  ["<tab><tab>l"] = { "<cmd>tablast<cr>", "n", desc = "Go to last tab" },
  ["<tab>L"] = { tabpage_move_right, "n", desc = "Move tab right" },
  ["<tab>H"] = { tabpage_move_left, "n", desc = "Move tab left" },
  ["<tab><tab>H"] = { "<cmd>tabm 0<cr>", "n", desc = "Move tab at first" },
  ["<tab><tab>L"] = { "<cmd>tabm $<cr>", "n", desc = "Move tab at end" },
  ["<tab>p"] = { "g<tab>", "n", desc = "Go to previous tab" },
  ["<tab>1"] = { "<cmd>1tabnext<cr>", "n", desc = "Tab 1" },
  ["<tab>2"] = { "<cmd>2tabnext<cr>", "n", desc = "Tab 2" },
  ["<tab>3"] = { "<cmd>3tabnext<cr>", "n", desc = "Tab 3" },
  ["<tab>4"] = { "<cmd>4tabnext<cr>", "n", desc = "Tab 4" },
  ["<tab>5"] = { "<cmd>5tabnext<cr>", "n", desc = "Tab 5" },
  ["<tab>6"] = { "<cmd>6tabnext<cr>", "n", desc = "Tab 6" },
  ["<tab>7"] = { "<cmd>7tabnext<cr>", "n", desc = "Tab 7" },
  ["<tab>8"] = { "<cmd>8tabnext<cr>", "n", desc = "Tab 8" },
  ["<tab>9"] = { "<cmd>9tabnext<cr>", "n", desc = "Tab 9" },
}
