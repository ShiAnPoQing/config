local keys = {
  OPEN_CMDWIN_EXECMD = "q:",
  OPEN_CMDWIN_SEARCH = "q/",
  OPEN_CMDWIN_SEARCH_BACK = "q?",
  SELECT_EXPR_REG_HISTORY = "g=",
  SELECT_SEARCH_BACK_HISTORY = "g?",
  SELECT_SEARCH_HISTORY = "g/",
  SELECT_EXECMD_HISTORY = "g:",
  -- SELECT_INPUT_HISTORY = "",
  -- SELECT_ALL_HISTORY = "",
  GOTO_NEWER_CHANGE = "go",
  GOTO_OLDER_CHANGE = "gi",

  TOGGLE_COMMENT = "<C-/>",
  TOGGLE_COMMENT_ALT1 = "<C-_>",

  CTRL_BS = "<C-BS>",
  -- CTRL_/
}

if vim.env.TERM == "xterm-ghostty" or vim.env.TERM == "tmux-256color" then
  keys.CTRL_BS = "<F17>"
end

return keys 

