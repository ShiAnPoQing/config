return {
  dir = "~/.config/nvim/pack/custom/opt/treesitter-textobject.nvim",
  keys = {
    {
      "<leader>ims",
      function()
        require("treesitter-textobject").textobject({
          language = "javascript",
          query = "import.source",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "javascript",
      desc = "@import.source",
    },
    {
      "<leader>ims",
      function()
        require("treesitter-textobject").textobject({
          language = "typescript",
          query = "import.source",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescript",
      desc = "@import.source",
    },
    {
      "<leader>ims",
      function()
        require("treesitter-textobject").textobject({
          language = "tsx",
          query = "import.source",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescriptreact",
      desc = "@import.source",
    },
    {
      "<leader>imn",
      function()
        require("treesitter-textobject").textobject({
          language = "typescript",
          query = "import.clause",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescript",
      desc = "@import.clause",
    },
    {
      "<leader>imn",
      function()
        require("treesitter-textobject").textobject({
          language = "tsx",
          query = "import.clause",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescriptreact",
      desc = "@import.clause",
    },
    {
      "<leader>imn",
      function()
        require("treesitter-textobject").textobject({
          language = "javascript",
          query = "import.clause",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "javascript",
      desc = "@import.clause",
    },
    {
      "<leader>jo",
      function()
        require("treesitter-textobject").textobject({
          language = "tsx",
          query = "jsx_element.outer",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescriptreact",
      desc = "@jsx_element.outer",
    },
    {
      "<leader>ji",
      function()
        require("treesitter-textobject").textobject({
          language = "tsx",
          query = "jsx_element.inner",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescriptreact",
      desc = "@jsx_element.inner",
    },
    {
      "<leader>tn",
      function()
        require("treesitter-textobject").textobject({
          language = "typescript",
          query = "type.name",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescript",
      desc = "@type.name",
    },
    {
      "<leader>tn",
      function()
        require("treesitter-textobject").textobject({
          language = "tsx",
          query = "type.name",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescriptreact",
      desc = "@type.name",
    },
    {
      "<leader>tv",
      function()
        require("treesitter-textobject").textobject({
          language = "typescript",
          query = "type.value",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescript",
      desc = "@type.value",
    },
    {
      "<leader>tv",
      function()
        require("treesitter-textobject").textobject({
          language = "tsx",
          query = "type.value",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescriptreact",
      desc = "@type.value",
    },
    {
      "<leader>tin",
      function()
        require("treesitter-textobject").textobject({
          language = "typescript",
          query = "interface.name",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescript",
      desc = "@interface.name",
    },
    {
      "<leader>tin",
      function()
        require("treesitter-textobject").textobject({
          language = "tsx",
          query = "interface.name",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescriptreact",
      desc = "@interface.name",
    },
    {
      "<leader>tiv",
      function()
        require("treesitter-textobject").textobject({
          language = "typescript",
          query = "interface.body",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescript",
      desc = "@interface.body",
    },
    {
      "<leader>tiv",
      function()
        require("treesitter-textobject").textobject({
          language = "tsx",
          query = "interface.body",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescriptreact",
      desc = "@interface.body",
    },
    {
      "<leader>fn",
      function()
        require("treesitter-textobject").textobject({
          language = "typescript",
          query = "function.name",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescript",
      desc = "@function.name",
    },
    {
      "<leader>fn",
      function()
        require("treesitter-textobject").textobject({
          language = "tsx",
          query = "function.name",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescriptreact",
      desc = "@function.name",
    },
    {
      "<leader>fn",
      function()
        require("treesitter-textobject").textobject({
          language = "javascript",
          query = "function.name",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "javascript",
      desc = "@function.name",
    },
    {
      "<leader>fn",
      function()
        require("treesitter-textobject").textobject({
          language = "lua",
          query = "function.name",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "lua",
      desc = "@function.name",
    },
    {
      "<leader>fn",
      function()
        require("treesitter-textobject").textobject({
          language = "c",
          query = "function.name",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "c",
      desc = "@function.name",
    },
    {
      "<leader>fc",
      function()
        require("treesitter-textobject").textobject({
          language = "lua",
          query = "function.call",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "lua",
      desc = "@function.call",
    },
    {
      "<leader>fp",
      function()
        require("treesitter-textobject").textobject({
          language = "lua",
          query = "parameter",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "lua",
      desc = "@parameter",
    },
    {
      "<leader>fo",
      function()
        require("treesitter-textobject").textobject({
          language = "lua",
          query = "function.outer",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "lua",
      desc = "@function.outer",
    },
    {
      "<leader>fo",
      function()
        require("treesitter-textobject").textobject({
          language = "typescript",
          query = "function.outer",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescript",
      desc = "@function.outer",
    },
    {
      "<leader>fo",
      function()
        require("treesitter-textobject").textobject({
          language = "tsx",
          query = "function.outer",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescriptreact",
      desc = "@function.outer",
    },
    {
      "<leader>fo",
      function()
        require("treesitter-textobject").textobject({
          language = "javascript",
          query = "function.outer",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "javascript",
      desc = "@function.outer",
    },
    {
      "<leader>fo",
      function()
        require("treesitter-textobject").textobject({
          language = "c",
          query = "function.outer",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "c",
      desc = "@function.outer",
    },
    {
      "<leader>fi",
      function()
        require("treesitter-textobject").textobject({
          language = "lua",
          query = "function.inner",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "lua",
      desc = "@function.inner",
    },
    {
      "<leader>fi",
      function()
        require("treesitter-textobject").textobject({
          language = "typescript",
          query = "function.inner",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescript",
      desc = "@function.inner",
    },
    {
      "<leader>fi",
      function()
        require("treesitter-textobject").textobject({
          language = "tsx",
          query = "function.inner",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescriptreact",
      desc = "@function.inner",
    },
    {
      "<leader>fi",
      function()
        require("treesitter-textobject").textobject({
          language = "javascript",
          query = "function.inner",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "javascript",
      desc = "@function.inner",
    },
    {
      "<leader>fi",
      function()
        require("treesitter-textobject").textobject({
          language = "c",
          query = "function.inner",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "c",
      desc = "@function.inner",
    },
    {
      "<leader>fr",
      function()
        require("treesitter-textobject").textobject({
          language = "lua",
          query = "function.return",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "lua",
      desc = "@function.return",
    },
    {
      "<leader>fr",
      function()
        require("treesitter-textobject").textobject({
          language = "typescript",
          query = "function.return",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescript",
      desc = "@function.return",
    },
    {
      "<leader>fr",
      function()
        require("treesitter-textobject").textobject({
          language = "tsx",
          query = "function.return",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescriptreact",
      desc = "@function.return",
    },
    {
      "<leader>fr",
      function()
        require("treesitter-textobject").textobject({
          language = "javascript",
          query = "function.return",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "javascript",
      desc = "@function.return",
    },
    {
      "<leader>fr",
      function()
        require("treesitter-textobject").textobject({
          language = "c",
          query = "function.return",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "c",
      desc = "@function.return",
    },
    {
      "<leader>so",
      function()
        require("treesitter-textobject").textobject({
          language = "lua",
          query = "statement.outer",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "lua",
      desc = "@statement.outer",
    },
    {
      "<leader>so",
      function()
        require("treesitter-textobject").textobject({
          language = "typescript",
          query = "statement.outer",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescript",
      desc = "@statement.outer",
    },
    {
      "<leader>so",
      function()
        require("treesitter-textobject").textobject({
          language = "tsx",
          query = "statement.outer",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescriptreact",
      desc = "@statement.outer",
    },
    {
      "<leader>so",
      function()
        require("treesitter-textobject").textobject({
          language = "javascript",
          query = "statement.outer",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "javascript",
      desc = "@statement.outer",
    },
    {
      "<leader>so",
      function()
        require("treesitter-textobject").textobject({
          language = "c",
          query = "statement.outer",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "c",
      desc = "@statement.outer",
    },
    {
      "<leader>si",
      function()
        require("treesitter-textobject").textobject({
          language = "lua",
          query = "statement.inner",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "lua",
      desc = "@statement.inner",
    },
    {
      "<leader>si",
      function()
        require("treesitter-textobject").textobject({
          language = "typescript",
          query = "statement.inner",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescript",
      desc = "@statement.inner",
    },
    {
      "<leader>si",
      function()
        require("treesitter-textobject").textobject({
          language = "tsx",
          query = "statement.inner",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescriptreact",
      desc = "@statement.inner",
    },
    {
      "<leader>si",
      function()
        require("treesitter-textobject").textobject({
          language = "javascript",
          query = "statement.inner",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "javascript",
      desc = "@statement.inner",
    },
    {
      "<leader>cd",
      function()
        require("treesitter-textobject").textobject({
          language = "lua",
          query = "condition",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "lua",
      desc = "@condition",
    },
    {
      "<leader>cd",
      function()
        require("treesitter-textobject").textobject({
          language = "typescript",
          query = "condition",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescript",
      desc = "@condition",
    },
    {
      "<leader>cd",
      function()
        require("treesitter-textobject").textobject({
          language = "tsx",
          query = "condition",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescriptreact",
      desc = "@condition",
    },
    {
      "<leader>cd",
      function()
        require("treesitter-textobject").textobject({
          language = "javascript",
          query = "condition",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "javascript",
      desc = "@condition",
    },
    {
      "<leader>cd",
      function()
        require("treesitter-textobject").textobject({
          language = "c",
          query = "condition",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "c",
      desc = "@condition",
    },
    {
      "<leader>cd",
      function()
        require("treesitter-textobject").textobject({
          language = "latex",
          query = "command",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "tex",
      desc = "@command",
    },
    {
      "<leader>el",
      function()
        require("treesitter-textobject").textobject({
          language = "lua",
          query = "expression_list",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "lua",
      desc = "@expression_list",
    },
    {
      "<leader>el",
      function()
        require("treesitter-textobject").textobject({
          language = "typescript",
          query = "expression_list",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescript",
      desc = "@expression_list",
    },
    {
      "<leader>el",
      function()
        require("treesitter-textobject").textobject({
          language = "tsx",
          query = "expression_list",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescriptreact",
      desc = "@expression_list",
    },
    {
      "<leader>el",
      function()
        require("treesitter-textobject").textobject({
          language = "javascript",
          query = "expression_list",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "javascript",
      desc = "@expression_list",
    },
    {
      "<leader>=l",
      function()
        require("treesitter-textobject").textobject({
          language = "lua",
          query = "equal.right",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "lua",
      desc = "@equal.right",
    },
    {
      "<leader>=l",
      function()
        require("treesitter-textobject").textobject({
          language = "typescript",
          query = "equal.right",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescript",
      desc = "@equal.right",
    },
    {
      "<leader>=l",
      function()
        require("treesitter-textobject").textobject({
          language = "tsx",
          query = "equal.right",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescriptreact",
      desc = "@equal.right",
    },
    {
      "<leader>=l",
      function()
        require("treesitter-textobject").textobject({
          language = "javascript",
          query = "equal.right",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "javascript",
      desc = "@equal.right",
    },
    {
      "<leader>icd",
      function()
        require("treesitter-textobject").textobject({
          language = "c",
          query = "include",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "c",
      desc = "@include",
    },
    {
      "<leader>icp",
      function()
        require("treesitter-textobject").textobject({
          language = "c",
          query = "include.path",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "c",
      desc = "@include.path",
    },
    {
      "<leader>co",
      function()
        local function callback()
          require("treesitter-textobject").textobject({
            language = "lua",
            query = "comment.outer",
            scm = "textobjects",
          })
          require("repeat").set_operation(callback)
        end
        callback()
      end,
      mode = { "x", "o" },
      ft = "lua",
      desc = "@comment.outer",
    },
    {
      "<leader>ci",
      function()
        require("treesitter-textobject").textobject({
          language = "lua",
          query = "comment.inner",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "lua",
      desc = "@comment.inner",
    },
    {
      "ev",
      function()
        require("treesitter-textobject").textobject({
          language = "latex",
          query = "environment",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "tex",
      desc = "@environment",
    },
    {
      "eq",
      function()
        require("treesitter-textobject").textobject({
          language = "latex",
          query = "equation",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "tex",
      desc = "@equation",
    },
    {
      "<leader>pi",
      function()
        require("treesitter-textobject").textobject({
          language = "latex",
          query = "package.include",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "tex",
      desc = "@package.include",
    },
    {
      "<leader>cn",
      function()
        require("treesitter-textobject").textobject({
          language = "latex",
          query = "command.name",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "tex",
      desc = "@command.name",
    },
    {
      "<leader>ca",
      function()
        require("treesitter-textobject").textobject({
          language = "latex",
          query = "command.arg",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "tex",
      desc = "@command.arg",
    },
  },
  config = function(opt)
    require("treesitter-textobject").setup()
  end,
}
