local function get_visual_texts()
  local start_mark = vim.api.nvim_buf_get_mark(0, "<")
  local end_mark = vim.api.nvim_buf_get_mark(0, ">")

  return vim.api.nvim_buf_get_text(0, start_mark[1] - 1, start_mark[2], end_mark[1] - 1, end_mark[2] + 1, {})
end
return {
  ["*"] = { "*zz", "n" },
  ["#"] = { "#zz", "n" },
  --["%"] = { "%zz", "n" },
  ["<space>/"] = {
    function()
      local function get_visual_pos(condition)
        local _, row1, col1 = unpack(vim.fn.getpos("."))
        local _, row2, col2 = unpack(vim.fn.getpos("v"))
        if condition(row1, col1, row2, col2) then
          return row1, col1, row2, col2
        else
          return row2, col2, row1, col1
        end
      end
      local start_row, start_col, end_row, end_col = get_visual_pos(function(row1, col1, row2, col2)
        if row1 < row2 then
          return true
        elseif row1 == row2 then
          if col1 < col2 then
            return true
          end
        end
      end)
      local text = vim.api.nvim_buf_get_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, {})[1]
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", true)
      return "/" .. text .. "<CR>"
    end,
    "x",
    expr = true,
  },
  -- Replace word under cursor
  ["<space>s"] = {
    {
      [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
      "n",
    },
    {
      function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", true)
        local texts = get_visual_texts()
        if #texts > 1 then
          vim.notify("Can't substitute more line!", vim.log.levels.WARN)
        else
          local text = texts[1]
          vim.api.nvim_feedkeys(":", "n", false)
          vim.schedule(function()
            local cmd = "%s/\\<" .. vim.pesc(text) .. "\\>//gI"
            vim.fn.setcmdline(cmd, #cmd - 2)
          end)
        end
      end,
      "x",
    },
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

-- -- Quick substitute within selected area
-- map('x', 'sg', ':s//gc<Left><Left><Left>', { desc = 'Substitute Within Selection' })

-- -- C-r: Easier search and replace visual/select mode
-- map(
-- 	'x',
-- 	'<C-r>',
-- 	":<C-u>%s/\\V<C-R>=v:lua.get_visual_selection()<CR>"
-- 		.. '//gc<Left><Left><Left>',
-- 	{ desc = 'Replace Selection' }
-- )
