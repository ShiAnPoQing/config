local function visual_mode_textobject(textobject)
  local mode = vim.api.nvim_get_mode().mode
  if mode == "" then
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_feedkeys(textobject .. vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
    local start_row = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    local end_row = unpack(vim.api.nvim_buf_get_mark(0, ">"))

    vim.api.nvim_win_set_cursor(0, { start_row, cursor[2] })
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-v>", true, false, true), "nx", false)
    vim.api.nvim_win_set_cursor(0, { end_row, cursor[2] })
  else
    vim.api.nvim_feedkeys(textobject, "nx", false)
  end
end
return {
  -- textobject
  ["ww"] = { "aw", { "x", "o" } },
  ["ew"] = { "iw", { "x", "o" } },
  ["wW"] = { "aW", { "x", "o" } },
  ["eW"] = { "iW", { "x", "o" } },

  ["ws"] = {
    { "as", "o" },
    {
      function()
        visual_mode_textobject("as")
      end,
      "x",
    },
  },
  ["es"] = {
    { "is", "o" },
    {
      function()
        visual_mode_textobject("is")
      end,
      "x",
    },
  },
  ["wp"] = {
    {
      "ap",
      "o",
    },
    {
      function()
        visual_mode_textobject("ap")
      end,
      "x",
    },
  },
  ["ep"] = {
    {
      "ip",
      "o",
    },
    {
      function()
        visual_mode_textobject("ip")
      end,
      "x",
    },
  },

  ["w["] = { "a[", { "x", "o" } },
  ["e["] = { "i[", { "x", "o" } },

  ["w]"] = { "a]", { "x", "o" } },
  ["e]"] = { "i]", { "x", "o" } },

  ["w{"] = { "a}", { "x", "o" } },
  ["w}"] = { "a}", { "x", "o" } },
  ["e{"] = { "i}", { "x", "o" } },
  ["e}"] = { "i}", { "x", "o" } },

  ["w("] = { "a)", { "x", "o" } },
  ["e("] = { "i)", { "x", "o" } },

  ["w)"] = { "a)", { "x", "o" } },
  ["e)"] = { "i)", { "x", "o" } },

  ["w>"] = { "a>", { "x", "o" } },
  ["e>"] = { "i>", { "x", "o" } },
  ["w<"] = { "a>", { "x", "o" } },
  ["e<"] = { "i>", { "x", "o" } },
  ['w"'] = { 'a"', { "x", "o" } },
  ['e"'] = { 'i"', { "x", "o" } },
  ["w'"] = { "a'", { "x", "o" } },
  ["e'"] = { "i'", { "x", "o" } },
  ["w`"] = { "a`", { "x", "o" } },
  ["e`"] = { "i`", { "x", "o" } },
  ["el"] = {
    { "^og_", "x" },
    {
      function()
        vim.api.nvim_feedkeys("^vg_", "nx", false)
      end,
      "o",
    },
    desc = "inner line(non br)",
  },
  ["wl"] = {
    { "0o$h", "x" },
    {
      function()
        vim.api.nvim_feedkeys("0v$h", "nx", false)
      end,
      "o",
    },
    desc = "outer line(non br)",
  },
  -- <div> </div>
  ["wt"] = { "at", { "x", "o" } },
  ["et"] = { "it", { "x", "o" } },
  ["wa"] = {
    { "vggVG", "x" },
    {
      function()
        vim.api.nvim_feedkeys("ggVG", "nx", false)
      end,
      "o",
    },
    desc = "all(line)",
  },
  ["ea"] = {
    { "vgovG$", "x" },
    {
      function()
        vim.api.nvim_feedkeys("goVG", "nx", false)
      end,
      "o",
    },
    desc = "all",
  },
}
