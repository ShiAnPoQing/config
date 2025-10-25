local function get_visual_texts()
  local start_mark = vim.api.nvim_buf_get_mark(0, "<")
  local end_mark = vim.api.nvim_buf_get_mark(0, ">")

  return vim.api.nvim_buf_get_text(0, start_mark[1] - 1, start_mark[2], end_mark[1] - 1, end_mark[2] + 1, {})
end
return {
  -- Search cursor text
  ["*"] = { "*zz", "n" },
  -- Search cursor text
  ["#"] = { "#zz", "n" },
  --["%"] = { "%zz", "n" },
  -- Search visual text
  ["<space>/"] = {
    function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", true)
      local text = get_visual_texts()[1]
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
  -- ["n"] = {
  --   "nzzzv",
  --   "n",
  --   desc = "Search result shown at the middle",
  -- },
  -- ["N"] = {
  --   "Nzzzv",
  --   "n",
  --   desc = "Search result shown at the middle",
  -- },
  ["0n"] = {
    function()
      local pattern = vim.fn.getreg("/")
      if pattern == "" then
        return
      end
      local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
      local matches = vim.fn.matchbufline(vim.api.nvim_get_current_buf(), pattern, wininfo.topline, wininfo.botline)
      local key = require("magic.key"):init()
      key.compute(#matches)
      for _, value in ipairs(matches) do
        vim.print(value.byteidx)
        key.register({
          callback = function() end,
          one_key = {
            line = value.lnum - 1,
            virt_col = value.byteidx,
          },
          two_key = {
            line = value.lnum - 1,
            virt_col = value.byteidx,
          },
        })
      end
      key.on_key({})
    end,
    "n",
  },
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
