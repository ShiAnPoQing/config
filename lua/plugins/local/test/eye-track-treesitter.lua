return {
  name = "eye-track-treesitter.nvim",
  depend = "eye-track.nvim",
  key = {
    ["0{"] = {
      function()
        require("eye-track-treesitter").treesitter({
          language = "lua",
          query = "table.outer",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
    },
    ["0ims"] = {
      {
        function()
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
    ["0imn"] = {
      {
        function()
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
    ["0jo"] = {
      function()
        require("eye-track-treesitter").treesitter({
          language = "tsx",
          query = "jsx_element.outer",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      ft = "typescriptreact",
      desc = "@jsx_element.outer",
    },
    ["0tn"] = {
      {
        function()
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
    ["0tv"] = {
      {
        function()
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
    ["0tin"] = {
      {
        function()
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
    ["0tiv"] = {
      {
        function()
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
    ["0fn"] = {
      {
        function()
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
    ["0fc"] = {
      function()
        require("eye-track-treesitter").treesitter({
          language = "lua",
          query = "function.call",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      ft = "lua",
      desc = "@function.call",
    },
    ["0fp"] = {
      function()
        require("eye-track-treesitter").treesitter({
          language = "lua",
          query = "parameter.inner",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      ft = "lua",
      desc = "@parameter",
    },
    ["0fP"] = {
      function()
        require("eye-track-treesitter").treesitter({
          language = "lua",
          query = "parameter",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      ft = "lua",
      desc = "@parameter",
    },
    ["0fo"] = {
      {
        function()
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
    ["0fi"] = {
      {
        function()
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
    ["0fr"] = {
      {
        function()
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
    ["0so"] = {
      {
        function()
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
    ["0si"] = {
      {
        function()
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
    ["0cd"] = {
      {
        function()
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
    ["0el"] = {
      {
        function()
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
    ["0=l"] = {
      {
        function()
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
          require("eye-track-treesitter").treesitter({
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
    ["0icd"] = {
      function()
        require("eye-track-treesitter").treesitter({
          language = "c",
          query = "include",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      ft = "c",
      desc = "@include",
    },
    ["0icp"] = {
      function()
        require("eye-track-treesitter").treesitter({
          language = "c",
          query = "include.path",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      ft = "c",
      desc = "@include.path",
    },
    ["0co"] = {
      {
        function()
          local function callback()
            require("eye-track-treesitter").treesitter({
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
            require("eye-track-treesitter").treesitter({
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
    ["0ci"] = {
      function()
        require("eye-track-treesitter").treesitter({
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
        require("eye-track-treesitter").treesitter({
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
        require("eye-track-treesitter").treesitter({
          language = "latex",
          query = "equation",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      ft = "tex",
      desc = "@equation",
    },
    ["0pi"] = {
      function()
        require("eye-track-treesitter").treesitter({
          language = "latex",
          query = "package.include",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      ft = "tex",
      desc = "@package.include",
    },
    ["0cn"] = {
      function()
        require("eye-track-treesitter").treesitter({
          language = "latex",
          query = "command.name",
          scm = "textobjects",
        })
      end,
      { "x", "o" },
      ft = "tex",
      desc = "@command.name",
    },
    ["0ca"] = {
      function()
        require("eye-track-treesitter").treesitter({
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
}
