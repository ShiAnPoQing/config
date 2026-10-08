--- @class my.motion.NORMAL
local M = {}

function M.first() end
function M.last() end
--- @param offset_col integer
function M._first_non_blank(offset_col) end
function M.last_non_blank() end
function M.first_non_blank() end

function M.backward_word_start() end
function M.backward_word_end() end
function M.forward_word_start() end
function M.forward_word_end() end
function M.backward_WORD_start() end
function M.backward_WORD_end() end
function M.forward_WORD_start() end
function M.forward_WORD_end() end

return M
