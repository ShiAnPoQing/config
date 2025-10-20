return {
  ["<leader>cd"] = {
    "<cmd>CdFileDir<CR>",
    "n",
    desc = "Change directory to file",
  },
  ["<leader>tcd"] = {
    "<cmd>TcdFileDir<CR>",
    "n",
    desc = "Change directory to file(Tab page)",
  },
  ["<leader>lcd"] = {
    "<cmd>LcdFileDir<CR>",
    "n",
    desc = "Change directory to file(Current Buffer)",
  },
}

--[[
  将当前文件所在目录设置为工作目录： cd %:h
--]]
