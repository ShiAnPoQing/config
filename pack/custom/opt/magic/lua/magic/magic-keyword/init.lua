local M = {}

local Key = require("magic.key")
local Keyword = require("magic.keyword")
local Line_hl = require("magic.line-hl")

--- @class MagicKeywordOpts
--- @field keyword string | fun(opts):string
--- @field callback fun()
--- @field position number
--- @field should_visual boolean
--- @field should_capture? boolean

function M.magic_keyword(opts)
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local topline = wininfo.topline
  local botline = wininfo.botline
  ---@diagnostic disable-next-line: undefined-field
  local leftcol = wininfo.leftcol
  local rightcol = leftcol + wininfo.width - wininfo.textoff
  local position = opts.position
  local keyword = opts.keyword

  Line_hl:init(topline, botline)
  local key = Key:init()
  Keyword.main({
    keyword = keyword,
    topline = topline,
    botline = botline,
    leftcol = leftcol,
    rightcol = rightcol,
    should_capture = opts.should_capture,
    match_callback = function(count)
      key.compute(count)
    end,
    register_key = function(match_opts)
      local line = match_opts.line
      local start_col = match_opts.start_col
      local end_col = match_opts.end_col
      local virt_start_col = match_opts.virt_win_start_col
      local virt_end_col = match_opts.virt_win_end_col

      local col
      local virt_col

      if position == 1 then
        col = start_col
        virt_col = virt_start_col
      elseif position == 2 then
        col = end_col - 1
        virt_col = virt_end_col
      elseif position == 3 then
        col = start_col + math.floor((end_col - start_col) / 2)
        virt_col = virt_start_col + math.floor((virt_end_col - virt_start_col) / 2)
      end

      key.register({
        callback = function()
          opts.callback({
            line = line,
            col = col,
            virt_col = virt_col,
            start_col = start_col,
            end_col = end_col,
            virt_start_col = virt_start_col,
            virt_end_col = virt_end_col,
          })
        end,
        one_key = {
          line = line,
          virt_col = virt_col,
          visual = opts.should_visual and {
            start_col = start_col,
            end_col = end_col,
          },
        },
        two_key = {
          line = line,
          virt_col = virt_col,
          visual = opts.should_visual and {
            start_col = start_col,
            end_col = end_col,
          },
          hidden_second_key = function()
            return start_col + 1 == end_col
          end,
        },
      })
    end,
    end_callback = function()
      key.on_key({
        matched_callback = function()
          Line_hl:del_hl()
        end,
        unmatched_callback = function()
          Line_hl:del_hl()
        end,
      })
    end,
  })
end

return M
