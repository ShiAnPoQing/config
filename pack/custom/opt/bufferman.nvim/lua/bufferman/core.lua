local UI = require("bufferman.ui")

local M = {}

local function is_buflisted(buf)
  return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_get_option_value("buflisted", {
    buf = buf,
  })
end

local function create_fit()
  local pre_view

  return function()
    vim.api.nvim_set_option_value("modified", false, { buf = UI.bufnr })
    UI:fit_height(vim.api.nvim_buf_line_count(UI.bufnr))
    UI:fit_width(#vim.api.nvim_get_current_line())
    if pre_view then
      pre_view.lnum = vim.fn.line(".")
      pre_view.col = vim.fn.col(".")
      vim.fn.winrestview(pre_view)
    end
    pre_view = vim.fn.winsaveview()
  end
end

--- @param ctx Bufferman.UI.Hook.Submit.Context
local function diff_items(ctx, opts)
  local removed_items = vim.tbl_deep_extend("force", {}, ctx.items)
  for _, line in ipairs(ctx.lines) do
    line = vim.trim(line)
    local is_same
    for i, it in ipairs(ctx.items) do
      if line == it.text then
        is_same = true
        removed_items[i] = nil
      end
    end
    if not is_same then
      opts.added(line)
    end
  end
  for _, it in pairs(removed_items) do
    if it then
      opts.removed(it)
    end
  end
end

local function create_items(current_buf)
  --- @type Bufferman.UI.Item[]
  local items = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if is_buflisted(buf) then
      local buffer_name = vim.api.nvim_buf_get_name(buf)
      buffer_name = vim.fn.fnamemodify(buffer_name, ":.")
      --- @type Bufferman.UI.Item
      local item = {
        text = buffer_name,
        selected = false,
        data = { buf = buf },
      }
      if buffer_name == "" then
        item.text = "[No Name]"
      end
      if buf == current_buf then
        item.selected = true
      end
      table.insert(items, item)
    end
  end

  return items
end

function M:clean()
  for _, id in ipairs(self.autocmds or {}) do
    vim.api.nvim_del_autocmd(id)
  end
  self.autocmds = nil
  self.buf = nil
  self.win = nil
end

function M:init()
  self.win = vim.api.nvim_get_current_win()
  self.buf = vim.api.nvim_get_current_buf()
  local bufadd = vim.api.nvim_create_autocmd("BufAdd", {
    callback = function()
      self.buf = vim.api.nvim_win_get_buf(self.win)
      UI:update(create_items(self.buf))
    end,
  })
  self.autocmds = { bufadd }
end

function M.bufferman()
  if UI:is_open() then
    UI:close()
    return
  end
  M:init()
  UI:open({
    items = create_items(M.buf),
    select = {
      callback = function(ctx)
        local item = ctx.item
        if not item.data.buf then
          return
        end
        vim.api.nvim_win_set_buf(M.win, item.data.buf)
        M.buf = item.data.buf
        return true
      end,
      keymap = { "<cr>" },
    },
    close = {
      callback = function()
        M:clean()
      end,
      keymap = { "q", "<esc>" },
    },
    submit = {
      callback = function(ctx)
        diff_items(ctx, {
          added = function(text)
            local buf = vim.fn.bufadd(text == "" and text or vim.fs.abspath(text))
            vim.api.nvim_set_option_value("buflisted", true, { buf = buf })
          end,
          removed = function(item)
            if item.data.buf == M.buf then
              vim.api.nvim_buf_call(M.buf, function()
                vim.cmd.bdelete({ bang = ctx.bang })
              end)
            else
              vim.api.nvim_buf_delete(item.data.buf, { force = ctx.bang })
            end
          end,
        })
        M.buf = vim.api.nvim_win_get_buf(M.win)
        UI:update(create_items(M.buf))
      end,
      keymap = {},
    },
    name = "Bufferman",
  })
  UI:on("WinLeave", function()
    UI:close()
  end)
  UI:on({ "TextChanged", "TextChangedI" }, create_fit())
  UI:keymap("s", function() end)
end

return M
