local left_esc = {
  { "<Esc>", "i" },
  { "<C-u><ESC>", { "c" } },
  { "<C-\\><C-N>", "t" },
  desc = "Quit insert mode quickly",
}
local right_esc = {
  { "<Esc>l", "i" },
  { "<C-u><ESC>", { "c" } },
  { "<C-\\><C-N>", "t" },
  desc = "Quit insert mode quickly",
}
return {
  ["jk"] = left_esc,
  ["jj"] = left_esc,
  ["JK"] = left_esc,
  ["JJ"] = left_esc,
  ["kj"] = right_esc,
  ["kk"] = right_esc,
  ["KJ"] = right_esc,
  ["KK"] = right_esc,
}
