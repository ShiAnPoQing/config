local M = {}

local function_query = [[
; query
(function_declaration
 name: (identifier)
 parameters: (formal_parameters)
 body: (statement_block)
) @function

(arrow_function
  parameters: (formal_parameters)
  body: (statement_block)
) @arrow_function

(function_expression
  parameters: (formal_parameters)
  body: (statement_block)
) @function_expression
]]

local function set_text(buf, start_row, start_col, end_row, end_col, text)
  local lines = vim.split(text, "\n", { plain = true })
  vim.api.nvim_buf_set_text(buf, start_row, start_col, end_row, end_col, lines)
end

local function get_function_parts(node, buf)
  local data = {}
  for child, type in node:iter_children() do
    if type == "parameters" then
      data["parameters"] = vim.treesitter.get_node_text(child, buf)
    elseif type == "body" then
      data["body"] = vim.treesitter.get_node_text(child, buf)
    elseif type == "name" then
      data["name"] = vim.treesitter.get_node_text(child, buf)
    end
  end
  return data
end

local function anonymous_arrow_function_to_anonymous_function(buf, start_row, start_col, end_row, end_col, node)
  local data = get_function_parts(node, buf)
  set_text(buf, start_row, start_col, end_row, end_col, "function" .. data["parameters"] .. " " .. data["body"])
end

local function anonymous_function_to_anonymous_arrow_function(buf, start_row, start_col, end_row, end_col, node)
  local data = get_function_parts(node, buf)
  set_text(buf, start_row, start_col, end_row, end_col, data["parameters"] .. " => " .. data["body"])
end

local function name_function_to_name_arrow_function(buf, start_row, start_col, end_row, end_col, node)
  local data = get_function_parts(node, buf)
  set_text(buf, start_row, start_col, end_row, end_col,
    "const " .. data["name"] .. " = " .. data["parameters"] .. " => " .. data["body"])
end

function M.test()
  local query = vim.treesitter.query.parse("javascript", function_query)
  if query == nil then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local tree = vim.treesitter.get_parser(bufnr, "javascript"):parse()[1]

  local pos = vim.api.nvim_win_get_cursor(0)
  local cur_row = pos[1] - 1

  for id, node, metadata, match in query:iter_captures(tree:root(), bufnr, 0, -1) do
    local name = query.captures[id]
    local start_row, start_col, end_row, end_col = node:range()
    local buf = vim.api.nvim_get_current_buf()

    if name == "arrow_function" then
      if (cur_row >= start_row and cur_row <= end_row) or cur_row <= start_row then
        anonymous_arrow_function_to_anonymous_function(buf, start_row, start_col, end_row, end_col, node)
        return
      end
    elseif name == "function" then
      if (cur_row >= start_row and cur_row <= end_row) or cur_row <= start_row then
        name_function_to_name_arrow_function(buf, start_row, start_col, end_row, end_col, node)
        return
      end
    elseif name == "function_expression" then
      if (cur_row >= start_row and cur_row <= end_row) or cur_row <= start_row then
        anonymous_function_to_anonymous_arrow_function(buf, start_row, start_col, end_row, end_col, node)
        return
      end
    end
  end
end

return M
