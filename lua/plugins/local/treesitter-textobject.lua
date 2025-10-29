return {
  name = "treesitter-textobject.nvim",
  keys = {
    -- @import.source
    ["<leader>ims"] = {
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
    -- @import.clause
    ["<leader>imn"] = {
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
    -- @jsx_element.outer
    ["<leader>jo"] = {
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
    -- @jsx_element.inner
    ["<leader>ji"] = {
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
    -- @type.name
    ["<leader>tn"] = {
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
    -- @type.value
    ["<leader>tv"] = {
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
    -- @interface.name
    ["<leader>tin"] = {
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
    -- @interface.body
    ["<leader>tiv"] = {
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
    -- @function.name
    ["<leader>fn"] = {
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
      {
        function()
          require("treesitter-textobject").textobject({
            language = "c",
            query = "function.name",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "c",
      },
    },
    -- @function.call
    ["<leader>fc"] = {
      {
        function()
          require("treesitter-textobject").textobject({
            language = "lua",
            query = "function.call",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "lua",
      },
    },
    -- @function.outer
    ["<leader>fo"] = {
      {
        function()
          require("treesitter-textobject").textobject({
            language = "lua",
            query = "function.outer",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "lua",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "typescript",
            query = "function.outer",
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
            query = "function.outer",
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
            query = "function.outer",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "javascript",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "c",
            query = "function.outer",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "c",
      },
    },
    -- @function.inner
    ["<leader>fi"] = {
      {
        function()
          require("treesitter-textobject").textobject({
            language = "lua",
            query = "function.inner",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "lua",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "typescript",
            query = "function.inner",
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
            query = "function.inner",
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
            query = "function.inner",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "javascript",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "c",
            query = "function.inner",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "c",
      },
    },
    -- @function.return
    ["<leader>fr"] = {
      {
        function()
          require("treesitter-textobject").textobject({
            language = "lua",
            query = "function.return",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "lua",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "typescript",
            query = "function.return",
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
            query = "function.return",
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
            query = "function.return",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "javascript",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "c",
            query = "function.return",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "c",
      },
    },
    -- @statement.outer
    ["<leader>so"] = {
      {
        function()
          require("treesitter-textobject").textobject({
            language = "lua",
            query = "statement.outer",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "lua",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "typescript",
            query = "statement.outer",
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
            query = "statement.outer",
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
            query = "statement.outer",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "javascript",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "c",
            query = "statement.outer",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "c",
      },
    },
    -- @statement.inner
    ["<leader>si"] = {
      {
        function()
          require("treesitter-textobject").textobject({
            language = "lua",
            query = "statement.inner",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "lua",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "typescript",
            query = "statement.inner",
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
            query = "statement.inner",
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
            query = "statement.inner",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "javascript",
      },
    },
    -- @condition
    ["<leader>cd"] = {
      {
        function()
          require("treesitter-textobject").textobject({
            language = "lua",
            query = "condition",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "lua",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "typescript",
            query = "condition",
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
            query = "condition",
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
            query = "condition",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "javascript",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "c",
            query = "condition",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "c",
      },
    },
    -- @expression_list
    ["<leader>el"] = {
      {
        function()
          require("treesitter-textobject").textobject({
            language = "lua",
            query = "expression_list",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "lua",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "typescript",
            query = "expression_list",
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
            query = "expression_list",
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
            query = "expression_list",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "javascript",
      },
    },

    -- @equal.right
    ["<leader>=l"] = {
      {
        function()
          require("treesitter-textobject").textobject({
            language = "lua",
            query = "equal.right",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "lua",
      },
      {
        function()
          require("treesitter-textobject").textobject({
            language = "typescript",
            query = "equal.right",
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
            query = "equal.right",
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
            query = "equal.right",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "javascript",
      },
    },
    ["<leader>icd"] = {
      {
        function()
          require("treesitter-textobject").textobject({
            language = "c",
            query = "include",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "c",
      },
    },
    ["<leader>icp"] = {
      {
        function()
          require("treesitter-textobject").textobject({
            language = "c",
            query = "include.path",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "c",
      },
    },
    ["<leader>co"] = {
      {
        function()
          local function callback()
            require("treesitter-textobject").textobject({
              language = "lua",
              query = "comment.outer",
              scm = "textobjects",
            })
            require("repeat"):set(callback)
          end
          callback()
        end,
        { "x", "o" },
        filetype = "lua",
      },
    },
    ["<leader>ci"] = {
      {
        function()
          require("treesitter-textobject").textobject({
            language = "lua",
            query = "comment.inner",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        filetype = "lua",
      },
    },
  },
  config = function(opt)
    require("treesitter-textobject").setup()
  end,
}
