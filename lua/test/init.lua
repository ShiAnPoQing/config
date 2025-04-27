local M = {}

local events = {}

function M.lsp(Args)
  local bufnr = vim.api.nvim_get_current_buf()
  local params = vim.lsp.util.make_position_params()
  local result = vim.lsp.buf_request_sync(bufnr, "textDocument/documentSymbol", params, 2000)
  print(vim.inspect(result))
end

function M.test()
  vim.ui.select({ "tabs", "spaces", "我真的", "箭头" }, {
    prompt = "Select tabs or spaces:",
    format_item = function(item)
      return "I'd like to choose " .. item
    end,
  }, function(choice)
    if choice == "spaces" then
      vim.o.expandtab = true
    else
      vim.o.expandtab = false
    end
  end)
end

function M.show()
  print(vim.inspect(events))
end

M.mark_ns = nil
M.mark_id = nil

function M.expand()
  local firstText = "function()"
  local endText = "end"
  vim.api.nvim_buf_set_lines(0, 0, 4, true, {
    firstText,
    "",
    "end ",
  })
  M.mark_ns = vim.api.nvim_create_namespace("myplugin")
  vim.api.nvim_set_hl(0, "IAmTest", { bg = "#ffffff" })
  vim.api.nvim_buf_set_extmark(0, M.mark_ns, 0, #firstText - 3, {
    end_row = 0,
    end_col = #firstText - 2,
    hl_group = "IAmTest",
  })
  M.mark_id = vim.api.nvim_buf_set_extmark(0, M.mark_ns, 0, #firstText - 2, {
    end_row = 0,
    end_col = #firstText - 1,
    hl_group = "IAmTest",
  })

  vim.api.nvim_buf_set_extmark(0, M.mark_ns, 0, #firstText - 1, {
    end_row = 0,
    end_col = #firstText,
    hl_group = "IAmTest",
  })
  --vim.api.nvim_buf_set_extmark(0, M.mark_ns, 0, #firstText - 3, {
  --	end_row = 0,
  --	end_col = #firstText - 2,
  --	hl_group = "IAmTest",
  --})
  --vim.api.nvim_buf_set_extmark(0, M.mark_ns, 2, #endText, {
  --	end_row = 2,
  --	end_col = #endText + 1,
  --	hl_group = "IAmTest",
  --})
end

function M.getMark()
  print(vim.inspect(vim.api.nvim_buf_get_extmark_by_id(0, M.mark_ns, M.mark_id, {})))
end

function M.nvim_buf_attach()
  events = {}
  vim.api.nvim_buf_attach(0, true, {
    on_lines = function(lines, handle, changedtick, firstline, new_lastline)
      -- print("lines" .. lines)
      -- print("handle" .. handle)
      -- print("changedtick" .. changedtick)
      -- print("firstline" .. firstline)
      -- print("最后更改的行" .. new_lastline)
      -- print(lines)
      -- local lines = vim.api.nvim_buf_get_lines(handle, firstline, new_lastline, true)
      -- print(vim.inspect(lines))
      -- table.insert(events, { ... })
      -- print(vim.inspect(events))
    end,
    on_bytes = function(_, handle, changedtick, startline, startCol, un, afterline, afterCol, len, a, c, e)
      print("起始行（0）： " .. startline)
      print("起始列： " .. startCol)
      print("到缓冲区的开始的偏移量: " .. un)
      print("相对于起始行的偏移量: " .. afterline)
      print("相对旧结束列: " .. afterCol)
      print("更改后的文本的旧结束字节长度： " .. len)
      print("新结束行： " .. a)
      print("新结束列: " .. c)
      print("字节长度：" .. e)
    end,
  })
end

function M.insertPre()
  vim.api.nvim_create_autocmd("InsertCharPre", {
    pattern = "*",
    callback = function()
      local char = vim.v.char -- 获取当前输入的字符
      print("输入字符:", char) -- 打印到命令行
    end,
  })
end

return M
