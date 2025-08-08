local M = {}

local Key = require("custom.plugins.magic.key")
local Keyword = require("custom.plugins.magic.keyword")
local Line_hl = require("custom.plugins.magic.line-highlight")

local keywords = {
  ["word_inner"] = "\\k\\+",
  ["word_outer"] = "\\k\\+\\s*",
  ["WORD_inner"] = "\\S\\+",
  ["WORD_outer"] = "\\S\\+\\s*",
}

--- @class MagicKeyword
--- @field keyword string | fun(opts):string
--- @field callback function
--- @field key_position number
--- @field should_visual boolean

--- @param opts MagicKeyword
function M.magic_keyword(opts)
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local topline = wininfo.topline
  local botline = wininfo.botline
  local leftcol = wininfo.leftcol
  local rightcol = leftcol + wininfo.width - wininfo.textoff
  local cursor = vim.api.nvim_win_get_cursor(0)

  local should_visual = opts.should_visual
  local key_position = opts.key_position
  local in_visual = should_visual and "InVisual" or ""

  local hl_group_next_key = "CustomMagicNextKey" .. in_visual
  local hl_group_next_key1 = "CustomMagicNextKey1" .. in_visual
  local hl_group_next_key2 = "CustomMagicNextKey2" .. in_visual

  local keyword

  if type(opts.keyword) == "function" then
    keyword = opts.keyword(keywords)
  elseif type(opts.keyword) == "string" then
    keyword = opts.keyword
  end

  Key:init({
    clean = function()
      Line_hl:del_hl()
      Keyword:clean()
    end,
  })
  Keyword:init({
    cursor = cursor,
    topline = topline,
    botline = botline,
    leftcol = leftcol,
    rightcol = rightcol,
    keyword = keyword,
  })

  Line_hl:init(topline, botline)

  Keyword:match_keyword()
  Key:compute_key(Keyword.keyword_count)
  Keyword:set_keyword_callback(function(line, start_col, end_col, virt_start_col, virt_end_col)
    local col
    local virt_col

    if key_position == 1 then
      col = start_col
      virt_col = virt_start_col - leftcol
    elseif key_position == 2 then
      col = end_col - 1
      virt_col = virt_end_col - leftcol
    end

    -- extmark 必须使用 display width 位置
    Key:register({
      callback = function()
        opts.callback({
          line = line,
          col = col,
          start_col = start_col,
          end_col = end_col,
          virt_col = virt_col,
          virt_start_col = virt_start_col,
          virt_end_col = virt_end_col,
        })
      end,
      one_key = {
        set_extmark = function(opts)
          vim.api.nvim_buf_set_extmark(0, opts.ns_id, line, 0, {
            virt_text_win_col = virt_col,
            virt_text = { { opts.key, hl_group_next_key } },
          })
          if should_visual then
            vim.api.nvim_buf_set_extmark(0, opts.ns_id, line, start_col, {
              end_col = end_col,
              hl_group = "Visual",
            })
          end
        end,
      },
      two_key = {
        set_extmark = function(opts1, opts2)
          vim.api.nvim_buf_set_extmark(0, opts1.ns_id, line, 0, {
            virt_text_win_col = virt_col,
            virt_text = { { opts1.key, hl_group_next_key1 } },
          })
          if end_col - start_col ~= 1 then
            vim.api.nvim_buf_set_extmark(0, opts2.ns_id, line, 0, {
              virt_text_win_col = virt_col + 1,
              virt_text = { { opts2.key, hl_group_next_key2 } },
            })
          end
          if should_visual then
            vim.api.nvim_buf_set_extmark(0, opts2.ns_id, line, start_col, {
              end_col = end_col,
              hl_group = "Visual",
            })
          end
        end,
        reset_extmark = function(opts)
          vim.api.nvim_buf_set_extmark(0, opts.ns_id, line, 0, {
            virt_text_win_col = virt_col,
            virt_text = { { opts.key, hl_group_next_key } },
          })
          if should_visual then
            vim.api.nvim_buf_set_extmark(0, opts.ns_id, line, start_col, {
              end_col = end_col,
              hl_group = "Visual",
            })
          end
        end,
      },
    })
  end)

  Key:ready_on_key()
end

return M
