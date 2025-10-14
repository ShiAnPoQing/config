return {
  -- textobject
  ["ww"] = { "aw", { "x", "o" } },
  ["ew"] = { "iw", { "x", "o" } },
  ["wW"] = { "aW", { "x", "o" } },
  ["eW"] = { "iW", { "x", "o" } },

  ["ws"] = { "as", { "x", "o" } },
  ["es"] = { "is", { "x", "o" } },
  ["wp"] = { "ap", { "x", "o" } },
  ["ep"] = { "ip", { "x", "o" } },

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
