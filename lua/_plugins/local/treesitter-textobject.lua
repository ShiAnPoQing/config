return {
  name = "treesitter-textobject.nvim",
  keys = {
    ["<space>fn"] = {
      {
        function()
          require("treesitter-textobject").textobject({
            language = "typescript",
            query = "function.name",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "typescript",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "tsx",
            query = "function.name",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "typescriptreact",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "javascript",
            query = "function.name",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "javascript",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "lua",
            query = "function.name",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "lua",
      },
    },
    ["<space>ims"] = {
      {
        function()
          require("treesitter-textobject").textobject({
            language = "typescript",
            query = "import.source",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "typescript",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "tsx",
            query = "import.source",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "typescriptreact",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "javascript",
            query = "import.source",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "javascript",
      },
    },
    ["<space>imn"] = {
      {
        function()
          require("treesitter-textobject").textobject({
            language = "typescript",
            query = "import.clause",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "typescript",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "tsx",
            query = "import.clause",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "typescriptreact",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "javascript",
            query = "import.clause",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "javascript",
      },
    },
    ["<space>jo"] = {
      function()
        require("treesitter-textobject").textobject({
          language = "tsx",
          query = "jsx_element.outer",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      filetype = "typescriptreact",
    },
    ["<space>ji"] = {
      function()
        require("treesitter-textobject").textobject({
          language = "tsx",
          query = "jsx_element.inner",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      filetype = "typescriptreact",
    },
    ["<space>tn"] = {
      {
        function()
          require("treesitter-textobject").textobject({
            language = "typescript",
            query = "type.name",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "typescript",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "tsx",
            query = "type.name",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "typescriptreact",
      },
    },
    ["<space>tv"] = {
      {
        function()
          require("treesitter-textobject").textobject({
            language = "typescript",
            query = "type.value",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "typescript",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "tsx",
            query = "type.value",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "typescriptreact",
      },
    },
    ["<space>tin"] = {
      {
        function()
          require("treesitter-textobject").textobject({
            language = "typescript",
            query = "interface.name",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "typescript",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "tsx",
            query = "interface.name",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "typescriptreact",
      },
    },
    ["<space>tiv"] = {
      {
        function()
          require("treesitter-textobject").textobject({
            language = "typescript",
            query = "interface.body",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "typescript",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "tsx",
            query = "interface.body",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "typescriptreact",
      },
    },
  },
  config = function(opt)
    require("treesitter-textobject").setup()
  end,
}
