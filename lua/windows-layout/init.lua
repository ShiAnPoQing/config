local Exchange = require("windows-layout.exchange")
local History = require("windows-layout.history")

local M = {
  win_exchange = Exchange.win_exchange,
  exchange_layout = Exchange.exchange_layout,
  exchange_pre = History.exchange_pre,
  exchange_next = History.exchange_next,
}

return M
