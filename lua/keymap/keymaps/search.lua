local function get_visual_texts()
  local start_mark = vim.api.nvim_buf_get_mark(0, "<")
  local end_mark = vim.api.nvim_buf_get_mark(0, ">")

  return vim.api.nvim_buf_get_text(0, start_mark[1] - 1, start_mark[2], end_mark[1] - 1, end_mark[2] + 1, {})
end

local function select_history(name, callback)
  local items = {}
  for i = 1, 100 do
    local his = vim.fn.histget(name, -i)
    if his == "" then
      break
    end
    items[#items + 1] = his
  end
  vim.ui.select(items, {
    prompt = "History[" .. name .. "]",
  }, function(item)
    if not item then
      return
    end
    vim.schedule(function()
      callback(item)
    end)
  end)
end

return {
  ["<space>&"] = { ":*&&<cr>", "n", desc = ":*&&" },
  -- Select history
  ["g="] = {
    function()
      select_history("=", function(item)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":<C-\\>e", true, false, true) .. item, "n", false)
      end)
    end,
    "n",
  },
  ["g?"] = {
    function()
      select_history("?", function(item)
        vim.api.nvim_feedkeys("?" .. item, "n", false)
      end)
    end,
    "n",
    desc = "Select ? history",
  },
  ["g/"] = {
    function()
      select_history("/", function(item)
        vim.api.nvim_feedkeys("/" .. item, "n", false)
      end)
    end,
    "n",
    desc = "Select / history",
  },
  ["g:"] = {
    function()
      select_history(":", function(item)
        vim.api.nvim_feedkeys(":" .. item, "n", false)
      end)
    end,
    "n",
    desc = "Select : history",
  },
  ["<space>s/"] = {
    {
      function()
        local last_search = vim.fn.getreg("/")
        return ":%s/\\<" .. last_search .. "\\>//gI<Left><Left><Left>"
      end,
      "n",
    },
    {
      function()
        local last_search = vim.fn.getreg("/")
        return ":s/\\<" .. last_search .. "\\>//gI<Left><Left><Left>"
      end,
      "x",
    },
    expr = true,
    desc = "Substitute last / search",
  },
  ["<space>s?"] = {
    {
      function()
        local last_search = vim.fn.getreg("?")
        return ":%s/\\<" .. last_search .. "\\>//gI<Left><Left><Left>"
      end,
      "n",
    },
    {
      function()
        local last_search = vim.fn.getreg("?")
        return ":s/\\<" .. last_search .. "\\>//gI<Left><Left><Left>"
      end,
      "x",
    },
    expr = true,
    desc = "Substitute last ? search",
  },
  -- Replace word under cursor
  ["<space>sW"] = {
    {
      [[:%s/\<<C-r><C-A>\>/<C-r><C-A>/gI<Left><Left><Left>]],
      "n",
    },
    {
      function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", true)
        local texts = get_visual_texts()
        local key = ""
        if #texts > 1 then
          vim.notify("Can't substitute more line!", vim.log.levels.WARN)
        else
          key = key .. ":%s/\\<" .. vim.pesc(texts[1]) .. "\\>//gI<Left><Left><Left>"
        end
        return key
      end,
      "x",
      expr = true,
      desc = "Substitute selection",
    },
  },
  ["<space>sw"] = {
    {
      [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
      "n",
    },
    {
      function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", true)
        local texts = get_visual_texts()
        local key = ""
        if #texts > 1 then
          vim.notify("Can't substitute more line!", vim.log.levels.WARN)
        else
          key = key .. ":%s/\\<" .. vim.pesc(texts[1]) .. "\\>//gI<Left><Left><Left>"
        end
        return key
      end,
      "x",
      expr = true,
      desc = "Substitute selection",
    },
  },
  ["<M-n>"] = {
    function()
      return "<C-o>" .. ({ "N", "n" })[vim.v.searchforward + 1]
    end,
    "i",
    desc = "<C-o>n",
    expr = true,
  },
  ["<M-N>"] = {
    function()
      return "<C-o>" .. ({ "n", "N" })[vim.v.searchforward + 1]
    end,
    "i",
    desc = "<C-o>N",
  },
  ["n"] = {
    { "'Nn'[v:searchforward].'zv'", "n" },
    { "'Nn'[v:searchforward]", { "x", "o" } },
    expr = true,
    desc = "Next Search Result[always rightdown]",
  },
  ["N"] = {
    { "'nN'[v:searchforward].'zv'", "n" },
    { "'nN'[v:searchforward]", { "x", "o" } },
    expr = true,
    desc = "Prev Search Result[always leftup]",
  },
  -- ["0n"] = {
  --   function()
  --     local pattern = vim.fn.getreg("/")
  --     if pattern == "" then
  --       return
  --     end
  --     local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  --     local matches = vim.fn.matchbufline(vim.api.nvim_get_current_buf(), pattern, wininfo.topline, wininfo.botline)
  --     local key = require("magic.key"):init()
  --     key.compute(#matches)
  --     for _, value in ipairs(matches) do
  --       key.register({
  --         callback = function() end,
  --         one_key = {
  --           ---@diagnostic disable-next-line: undefined-field
  --           line = value.lnum - 1,
  --           ---@diagnostic disable-next-line: undefined-field
  --           virt_col = value.byteidx,
  --         },
  --         two_key = {
  --           ---@diagnostic disable-next-line: undefined-field
  --           line = value.lnum - 1,
  --           ---@diagnostic disable-next-line: undefined-field
  --           virt_col = value.byteidx,
  --         },
  --       })
  --     end
  --     key.on_key({})
  --   end,
  --   "n",
  -- },
}
-- ["<space>/"] = {
--   function()
--     local function get_visual_pos(condition)
--       local _, row1, col1 = unpack(vim.fn.getpos("."))
--       local _, row2, col2 = unpack(vim.fn.getpos("v"))
--       if condition(row1, col1, row2, col2) then
--         return row1, col1, row2, col2
--       else
--         return row2, col2, row1, col1
--       end
--     end
--     local start_row, start_col, end_row, end_col = get_visual_pos(function(row1, col1, row2, col2)
--       if row1 < row2 then
--         return true
--       elseif row1 == row2 then
--         if col1 < col2 then
--           return true
--         end
--       end
--     end)
--     local text = vim.api.nvim_buf_get_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, {})[1]
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", true)
--     return "/" .. text .. "<CR>"
--   end,
--   "x",
--   expr = true,
-- },
