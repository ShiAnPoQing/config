local M = {}

function M.ChangeMoveSize(count, operate)
  local base_count

  if M.changemovesize_count then
    base_count = M.changemovesize_count
  else
    base_count = 1
    M.changemovesize_count = base_count
    M.changemovesize_base_count = base_count
  end

  if operate == "up" then
    M.changemovesize_count = base_count + count
  elseif operate == "down" then
    if base_count <= count then
      M.changemovesize_count = 1
    else
      M.changemovesize_count = base_count - count
    end
  end

  base_count = M.changemovesize_count

  -- require("plugin-keymap").add({
  --   ["H"] = { base_count .. "h", { "n", "x" } },
  --   ["L"] = { base_count .. "l", { "n", "x" } },
  --   ["J"] = { base_count .. "j", { "n", "x" } },
  --   ["K"] = { base_count .. "k", { "n", "x" } },
  -- })
end

function M.ChangeMoveSize_reset()
  if not M.changemovesize_base_count then
    return
  end

  M.changemovesize_count = M.changemovesize_base_count
  M.ChangeMoveSize(0, "reset")
end

return M
