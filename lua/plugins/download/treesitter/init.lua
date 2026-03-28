return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    version = "main",
    key = {
      ["]f"] = {
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
        end,
        "n",
        desc = "Next function start",
      },
      ["[f"] = {
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
        end,
        "n",
        desc = "Previous function start",
      },
      ["]F"] = {
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
        end,
        "n",
        desc = "Next function end",
      },
      ["[F"] = {
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
        end,
        "n",
        desc = "Previous function end",
      },
      ["]c"] = {
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@comment.outer", "textobjects")
        end,
        "n",
        desc = "Next comment start",
      },
      ["[c"] = {
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@comment.outer", "textobjects")
        end,
        "n",
        desc = "Previous comment start",
      },
      ["]C"] = {
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@comment.outer", "textobjects")
        end,
        "n",
        desc = "Next comment end",
      },
      ["[C"] = {
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@comment.outer", "textobjects")
        end,
        "n",
        desc = "Previous comment end",
      },
    },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          -- LazyVim extention to create buffer-local keymaps
          -- keys = {
          --   goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          --   goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
          --   goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          --   goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
          -- },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    version = "main",
    run = function()
      vim.cmd("TSUpdate")
    end,
    config = function()
      local langs = {
        "c",
        "cpp",
        "javascript",
        "typescript",
        "tsx",
        "lua",
        "python",
        "go",
        "java",
        "rust",
        "kdl",
        "latex",
        "cmake",
        "git_config",
        "gitignore",
        "make",
        "yaml",
        "markdown",
        "bash",
        "html",
        "css",
        "vimdoc",
        "xml",
        "jsdoc",
        "json",
        "diff",
        "query",
        "vue",
        "vim",
        "commonlisp",
      }
      local TS = require("nvim-treesitter")
      TS.setup({})
      TS.install(langs)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = vim.list_extend(langs, { "typescriptreact", "javascriptreact", "tex", "jsonc" }),
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
}
