local function create_treesitter_textobject_keymap(opts)
  return {
    function()
      require("custom.plugins.treesitter-query.treesitter-textobject").textobject({
        language = opts.language,
        scm = "mytextobjects",
        query = opts.query
      })
    end,
    { "o",                     "x" },
    { filetype = opts.filetype }
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
  ["wl"] = { "^o$h", { "x" } },

  -- <div> </div>
  ["wt"] = { "at", { "x", "o" } },
  ["et"] = { "it", { "x", "o" } },

  ["<leader>fn"] = {
    create_treesitter_textobject_keymap({
      language = "tsx",
      query = "function_name",
      filetype = "typescriptreact"
    }),
    create_treesitter_textobject_keymap({
      language = "typescript",
      query = "function_name",
      filetype = "typescript"
    }),
    create_treesitter_textobject_keymap({
      language = "javascript",
      query = "function_name",
      filetype = "typescript"
    })
  },
  ["<leader>eh"] = {
    create_treesitter_textobject_keymap({
      language = "tsx",
      query = "variable_name",
      filetype = "typescriptreact"
    }),
    create_treesitter_textobject_keymap({
      language = "typescript",
      query = "variable_name",
      filetype = "typescript"
    }),
    create_treesitter_textobject_keymap({
      language = "javascript",
      query = "variable_name",
      filetype = "typescript"
    })
  },
  ["<leader>el"] = {
    create_treesitter_textobject_keymap({
      language = "tsx",
      query = "variable_value",
      filetype = "typescriptreact"
    }),
    create_treesitter_textobject_keymap({
      language = "typescript",
      query = "variable_value",
      filetype = "typescript"
    }),
    create_treesitter_textobject_keymap({
      language = "javascript",
      query = "variable_value",
      filetype = "typescript"
    })
  },

  ["<leader>is"] = {
    create_treesitter_textobject_keymap({
      language = "tsx",
      query = "import_source",
      filetype = "typescriptreact"
    }),
    create_treesitter_textobject_keymap({
      language = "typescript",
      query = "import_source",
      filetype = "typescript"
    }),
    create_treesitter_textobject_keymap({
      language = "javascript",
      query = "import_source",
      filetype = "typescript"
    })
  },
  ["<leader>in"] = {
    create_treesitter_textobject_keymap({
      language = "tsx",
      query = "import_clause",
      filetype = "typescriptreact"
    }),
    create_treesitter_textobject_keymap({
      language = "typescript",
      query = "import_clause",
      filetype = "typescript"
    }),
    create_treesitter_textobject_keymap({
      language = "javascript",
      query = "import_clause",
      filetype = "typescript"
    })
  }
}
