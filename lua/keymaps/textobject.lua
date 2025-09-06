local function create_treesitter_textobject_keymap(opts)
  return {
    function()
      require("custom.plugins.treesitter-query.treesitter-textobject").textobject({
        language = opts.language,
        scm = "mytextobjects",
        query = opts.query,
      })
    end,
    { "o", "x" },
    filetype = opts.filetype,
  }
end

local function create_js_treesitter_textobject_keymap(query)
  return {
    create_treesitter_textobject_keymap({
      language = "tsx",
      query = query,
      filetype = "typescriptreact",
    }),
    create_treesitter_textobject_keymap({
      language = "typescript",
      query = query,
      filetype = "typescript",
    }),
    create_treesitter_textobject_keymap({
      language = "javascript",
      query = query,
      filetype = "javascript",
    }),
    create_treesitter_textobject_keymap({
      language = "lua",
      query = query,
      filetype = "lua",
    }),
  }
end

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

  ["<space>fn"] = create_js_treesitter_textobject_keymap("function_name"),
  -- ["<space>eh"] = create_js_treesitter_textobject_keymap("variable_name"),
  -- ["<spae>el"] = create_js_treesitter_textobject_keymap("variable_value"),
  ["<leader>ims"] = create_js_treesitter_textobject_keymap("import_source"),
  ["<leader>imn"] = create_js_treesitter_textobject_keymap("import_clause"),

  ["<space>tn"] = create_js_treesitter_textobject_keymap("type_name"),
  ["<space>tv"] = create_js_treesitter_textobject_keymap("type_value"),
  ["<space>tin"] = create_js_treesitter_textobject_keymap("interface_name"),
  ["<space>tiv"] = create_js_treesitter_textobject_keymap("interface_body"),
  ["<space>af"] = create_js_treesitter_textobject_keymap("arrow_function"),
}
