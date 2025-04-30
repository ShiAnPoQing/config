local M = {
  currentRepeat = nil,
}
local queue = {}
local hadStart = false
local hadFixed = false

local function processQueue()
  if queue then
    for index, value in ipairs(queue) do
      local callback = queue[index]
      callback()
    end
  end
end

local function execRepeat()
  if queue then
    processQueue()
  else
    if type(M.currentRepeat) == "function" then
      M.currentRepeat()
    end
  end
end

function M.Repeat()
  if vim.v.count1 > 0 then
    for i = 1, vim.v.count1 do
      execRepeat()
    end
  else
    execRepeat()
  end
end

function M.Record(callback)
  if not hadFixed then
    M.currentRepeat = callback

    if hadStart then
      table.insert(queue, callback)
    else
      queue = nil
    end
  end
end

function M.RepeatTriggerFixed()
  if hadFixed then
    print("取消 Reqeat 固定")
    hadFixed = false
  else
    print("固定 Repeat")
    hadFixed = true
  end
end

function M.RecordStart()
  print("开始记录")
  queue = {}
  hadStart = true
end

function M.RecordEnd()
  print("结束记录")
  hadStart = false
end

function M.setup()
  require("plugin-keymap").add({
    [";rs"] = {
      function()
        M.RecordStart()
      end,
      "n",
    },
    [";re"] = {
      function()
        M.RecordEnd()
      end,
      "n",
    },
    [";rf"] = {
      function()
        M.RepeatTriggerFixed()
      end,
      "n",
    },
    -- repeat
    ["."] = {
      function()
        require("repeat").Repeat()
      end,
      { "n", "x" },
    },
  })
end

return M
