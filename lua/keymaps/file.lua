return {
  -- copy file name
  ["<leader>cf"] = {
    '<cmd>let @+ = expand("%")<CR>',
    { "n" },
  },
  -- copy file path
  ["<leader>cp"] = {
    '<cmd>let @+ = expand("%:p")<CR>',
    { "n" },
  },
  -- show file info
  [";sfi"] = {
    function()
      local S = require("show-file-info")
      S.showFileInfo()
      require("repeat").Record(function()
        S.showFileInfo()
      end)
    end,
    "n",
  },
}
