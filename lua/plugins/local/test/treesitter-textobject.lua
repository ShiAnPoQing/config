return {
  name = "treesitter-textobject",
  key = {
    ["<leader>ims"] = {
      {
        function()
          require("treesitter-textobject.select").select({
            language = "javascript",
            query = "import.source",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "javascript",
        desc = "@import.source",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "typescript",
            query = "import.source",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescript",
        desc = "@import.source",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "tsx",
            query = "import.source",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescriptreact",
        desc = "@import.source",
      },
    },
    ["<leader>imn"] = {
      {
        function()
          require("treesitter-textobject.select").select({
            language = "typescript",
            query = "import.clause",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescript",
        desc = "@import.clause",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "tsx",
            query = "import.clause",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescriptreact",
        desc = "@import.clause",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "javascript",
            query = "import.clause",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "javascript",
        desc = "@import.clause",
      },
    },
    ["<leader>jo"] = {
      function()
        require("treesitter-textobject.select").select({
          language = "tsx",
          query = "jsx_element.outer",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      ft = "typescriptreact",
      desc = "@jsx_element.outer",
    },
    ["<leader>tn"] = {
      {
        function()
          require("treesitter-textobject.select").select({
            language = "typescript",
            query = "type.name",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescript",
        desc = "@type.name",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "tsx",
            query = "type.name",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescriptreact",
        desc = "@type.name",
      },
    },
    ["<leader>tv"] = {
      {
        function()
          require("treesitter-textobject.select").select({
            language = "typescript",
            query = "type.value",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescript",
        desc = "@type.value",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "tsx",
            query = "type.value",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescriptreact",
        desc = "@type.value",
      },
    },
    ["<leader>tin"] = {
      {
        function()
          require("treesitter-textobject.select").select({
            language = "typescript",
            query = "interface.name",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescript",
        desc = "@interface.name",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "tsx",
            query = "interface.name",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescriptreact",
        desc = "@interface.name",
      },
    },
    ["<leader>tiv"] = {
      {
        function()
          require("treesitter-textobject.select").select({
            language = "typescript",
            query = "interface.body",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescript",
        desc = "@interface.body",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "tsx",
            query = "interface.body",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescriptreact",
        desc = "@interface.body",
      },
    },
    ["<leader>fn"] = {
      {
        function()
          require("treesitter-textobject.select").select({
            language = "typescript",
            query = "function.name",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescript",
        desc = "@function.name",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "tsx",
            query = "function.name",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescriptreact",
        desc = "@function.name",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "javascript",
            query = "function.name",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "javascript",
        desc = "@function.name",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "lua",
            query = "function.name",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "lua",
        desc = "@function.name",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "c",
            query = "function.name",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "c",
        desc = "@function.name",
      },
    },
    ["<leader>fc"] = {
      function()
        require("treesitter-textobject.select").select({
          language = "lua",
          query = "function.call",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      ft = "lua",
      desc = "@function.call",
    },
    ["<leader>fp"] = {
      function()
        require("treesitter-textobject.select").select({
          language = "lua",
          query = "parameter",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      ft = "lua",
      desc = "@parameter",
    },
    ["<leader>fo"] = {
      {
        function()
          require("treesitter-textobject.select").select({
            language = "lua",
            query = "function.outer",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "lua",
        desc = "@function.outer",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "typescript",
            query = "function.outer",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescript",
        desc = "@function.outer",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "tsx",
            query = "function.outer",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescriptreact",
        desc = "@function.outer",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "javascript",
            query = "function.outer",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "javascript",
        desc = "@function.outer",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "c",
            query = "function.outer",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "c",
        desc = "@function.outer",
      },
    },
    ["<leader>fi"] = {
      {
        function()
          require("treesitter-textobject.select").select({
            language = "lua",
            query = "function.inner",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "lua",
        desc = "@function.inner",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "typescript",
            query = "function.inner",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescript",
        desc = "@function.inner",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "tsx",
            query = "function.inner",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescriptreact",
        desc = "@function.inner",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "javascript",
            query = "function.inner",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "javascript",
        desc = "@function.inner",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "c",
            query = "function.inner",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "c",
        desc = "@function.inner",
      },
    },
    ["<leader>fr"] = {
      {
        function()
          require("treesitter-textobject.select").select({
            language = "lua",
            query = "function.return",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "lua",
        desc = "@function.return",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "typescript",
            query = "function.return",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescript",
        desc = "@function.return",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "tsx",
            query = "function.return",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescriptreact",
        desc = "@function.return",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "javascript",
            query = "function.return",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "javascript",
        desc = "@function.return",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "c",
            query = "function.return",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "c",
        desc = "@function.return",
      },
    },
    ["<leader>so"] = {
      {
        function()
          require("treesitter-textobject.select").select({
            language = "lua",
            query = "statement.outer",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "lua",
        desc = "@statement.outer",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "typescript",
            query = "statement.outer",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescript",
        desc = "@statement.outer",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "tsx",
            query = "statement.outer",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescriptreact",
        desc = "@statement.outer",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "javascript",
            query = "statement.outer",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "javascript",
        desc = "@statement.outer",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "c",
            query = "statement.outer",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "c",
        desc = "@statement.outer",
      },
    },
    ["<leader>si"] = {
      {
        function()
          require("treesitter-textobject.select").select({
            language = "lua",
            query = "statement.inner",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "lua",
        desc = "@statement.inner",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "typescript",
            query = "statement.inner",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescript",
        desc = "@statement.inner",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "tsx",
            query = "statement.inner",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescriptreact",
        desc = "@statement.inner",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "javascript",
            query = "statement.inner",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "javascript",
        desc = "@statement.inner",
      },
    },
    ["<leader>cd"] = {
      {
        function()
          require("treesitter-textobject.select").select({
            language = "lua",
            query = "condition",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "lua",
        desc = "@condition",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "typescript",
            query = "condition",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescript",
        desc = "@condition",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "tsx",
            query = "condition",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescriptreact",
        desc = "@condition",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "javascript",
            query = "condition",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "javascript",
        desc = "@condition",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "c",
            query = "condition",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "c",
        desc = "@condition",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "latex",
            query = "command",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "tex",
        desc = "@command",
      },
    },
    ["<leader>el"] = {
      {
        function()
          require("treesitter-textobject.select").select({
            language = "lua",
            query = "expression_list",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "lua",
        desc = "@expression_list",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "typescript",
            query = "expression_list",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescript",
        desc = "@expression_list",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "tsx",
            query = "expression_list",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescriptreact",
        desc = "@expression_list",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "javascript",
            query = "expression_list",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "javascript",
        desc = "@expression_list",
      },
    },
    ["<leader>=l"] = {
      {
        function()
          require("treesitter-textobject.select").select({
            language = "lua",
            query = "equal.right",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "lua",
        desc = "@equal.right",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "typescript",
            query = "equal.right",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescript",
        desc = "@equal.right",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "tsx",
            query = "equal.right",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "typescriptreact",
        desc = "@equal.right",
      },
      {
        function()
          require("treesitter-textobject.select").select({
            language = "javascript",
            query = "equal.right",
            scm = "textobjects",
          })
        end,
        { "x", "o" },
        ft = "javascript",
        desc = "@equal.right",
      },
    },
    ["<leader>icd"] = {
      function()
        require("treesitter-textobject.select").select({
          language = "c",
          query = "include",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      ft = "c",
      desc = "@include",
    },
    ["<leader>icp"] = {
      function()
        require("treesitter-textobject.select").select({
          language = "c",
          query = "include.path",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      ft = "c",
      desc = "@include.path",
    },
    ["<leader>co"] = {
      {
        function()
          local function callback()
            require("treesitter-textobject.select").select({
              language = "lua",
              query = "comment.outer",
              scm = "textobjects",
            })
            require("repeat").set_operation(callback)
          end
          callback()
        end,
        { "x", "o" },
        ft = "lua",
        desc = "@comment.outer",
      },
      {
        function()
          local function callback()
            require("treesitter-textobject.select").select({
              language = "latex",
              query = "comment.outer",
              scm = "textobjects",
            })
            require("repeat").set_operation(callback)
          end
          callback()
        end,
        { "x", "o" },
        ft = "tex",
        desc = "@comment.outer",
      },
    },
    ["<leader>ci"] = {
      function()
        require("treesitter-textobject.select").select({
          language = "lua",
          query = "comment.inner",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      ft = "lua",
      desc = "@comment.inner",
    },
    ["ev"] = {
      function()
        require("treesitter-textobject.select").select({
          language = "latex",
          query = "environment",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      ft = "tex",
      desc = "@environment",
    },
    ["eq"] = {
      function()
        require("treesitter-textobject.select").select({
          language = "latex",
          query = "equation",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      ft = "tex",
      desc = "@equation",
    },
    ["<leader>pi"] = {
      function()
        require("treesitter-textobject.select").select({
          language = "latex",
          query = "package.include",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      ft = "tex",
      desc = "@package.include",
    },
    ["<leader>cn"] = {
      function()
        require("treesitter-textobject.select").select({
          language = "latex",
          query = "command.name",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      ft = "tex",
      desc = "@command.name",
    },
    ["<leader>ca"] = {
      function()
        require("treesitter-textobject.select").select({
          language = "latex",
          query = "command.arg",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      ft = "tex",
      desc = "@command.arg",
    },
  },
  config = function()
    require("treesitter-textobject").setup()
  end,
}
