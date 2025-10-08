local function jump(opts, position)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local count
  local jump_key
  local move_key

  if opts.line > cursor[1] then
    count = opts.line - cursor[1]
    if count == 0 then
      jump_key = ""
    else
      jump_key = count .. "j"
    end
  else
    count = cursor[1] - opts.line
    if count == 0 then
      jump_key = ""
    else
      jump_key = count .. "k"
    end
  end

  if position == "left" then
    move_key = "g0"
  elseif position == "right" then
    move_key = "g$"
  end

  vim.api.nvim_feedkeys(jump_key .. move_key, "nx", false)
end

return {
  ["0ah"] = {
    function()
      require("magic").magic_screen({
        position = "left",
        callback = function(opts)
          jump(opts, "left")
        end,
      })
    end,
    { "n", "x" },
  },
  ["0al"] = {
    function()
      require("magic").magic_screen({
        position = "right",
        callback = function(opts)
          jump(opts, "right")
        end,
      })
    end,
    { "n", "x" },
  },
}
