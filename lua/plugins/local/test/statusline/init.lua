return {
  name = "plain-statusline.nvim",
  depend = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local colors = require("paradox.colors").load()
    local Mode = require("plugins.local.test.statusline.mode")
    local Git = require("plugins.local.test.statusline.git")
    local Diagnostic = require("plugins.local.test.statusline.diagnostic")
    local File = require("plugins.local.test.statusline.file")
    local Cursor = require("plugins.local.test.statusline.cursor")

    local Space = {
      provider = " ",
    }

    local Algins = {
      provider = "%=",
    }

    require("plain-statusline").setup({
      mode_hls = {
        n = {
          bg = colors.purple,
          fg = colors.bg1,
          bold = true,
        },
        no = {
          bg = colors.yellow,
          fg = colors.bg1,
          bold = true,
        },
        nov = {
          bg = colors.yellow,
          fg = colors.bg1,
          bold = true,
        },
        noV = {
          bg = colors.yellow,
          fg = colors.bg1,
          bold = true,
        },
        ["no\22"] = {
          bg = colors.yellow,
          fg = colors.bg1,
          bold = true,
        },
        niI = {
          bg = colors.purple,
          fg = colors.bg1,
          bold = true,
        },
        niR = {
          bg = colors.purple,
          fg = colors.bg1,
          bold = true,
        },
        niV = {
          bg = colors.purple,
          fg = colors.bg1,
          bold = true,
        },
        nt = {
          bg = colors.purple,
          fg = colors.bg1,
          bold = true,
        },
        ntT = {
          bg = colors.purple,
          fg = colors.bg1,
          bold = true,
        },

        v = {
          bg = colors.magenta,
          fg = colors.bg1,
          bold = true,
        },
        vs = {
          bg = colors.magenta,
          fg = colors.bg1,
          bold = true,
        },
        V = {
          bg = colors.magenta,
          fg = colors.bg1,
          bold = true,
        },
        Vs = {
          bg = colors.magenta,
          fg = colors.bg1,
          bold = true,
        },
        ["\22"] = {
          bg = colors.magenta,
          fg = colors.bg1,
          bold = true,
        },
        ["\22s"] = {
          bg = colors.magenta,
          fg = colors.bg1,
          bold = true,
        },

        s = {
          bg = colors.peach,
          fg = colors.bg1,
          bold = true,
        },
        S = {
          bg = colors.peach,
          fg = colors.bg1,
          bold = true,
        },
        ["\19"] = {
          bg = colors.peach,
          fg = colors.bg1,
          bold = true,
        },

        i = {
          bg = colors.green,
          fg = colors.bg1,
          bold = true,
        },
        ic = {
          bg = colors.green,
          fg = colors.bg1,
          bold = true,
        },
        ix = {
          bg = colors.green,
          fg = colors.bg1,
          bold = true,
        },

        R = {
          bg = colors.red,
          fg = colors.bg1,
          bold = true,
        },
        Rc = {
          bg = colors.red,
          fg = colors.bg1,
          bold = true,
        },
        Rx = {
          bg = colors.red,
          fg = colors.bg1,
          bold = true,
        },
        Rv = {
          bg = colors.red,
          fg = colors.bg1,
          bold = true,
        },
        Rvc = {
          bg = colors.red,
          fg = colors.bg1,
          bold = true,
        },
        Rvx = {
          bg = colors.red,
          fg = colors.bg1,
          bold = true,
        },

        c = {
          bg = colors.cyan,
          fg = colors.bg1,
          bold = true,
        },
        cr = {
          bg = colors.cyan,
          fg = colors.bg1,
          bold = true,
        },
        cv = {
          bg = colors.cyan,
          fg = colors.bg1,
          bold = true,
        },
        cvr = {
          bg = colors.cyan,
          fg = colors.bg1,
          bold = true,
        },

        -- r = "PROMPT",
        -- rm = "MORE",
        -- ["r?"] = "CONFIRM",
        -- ["!"] = "SHELL",
        t = {
          bg = colors.purple,
          fg = colors.bg1,
          bold = true,
        },
      },
      mode_names = {
        n = "NORMAL",
        no = "O-PENDING",
        nov = "O-PENDING(VISUAL)",
        noV = "O-PENDING(V-LINE)",
        ["no\22"] = "O-PENDING(V-BLOCK)",
        niI = "NORMAL(INSERT)",
        niR = "NORMAL(REPLACE)",
        niV = "NORMAL(V-REPLACE)",
        nt = "NORMAL(TERMINAL)",
        ntT = "NORMAL(TERMINAL)",

        v = "VISUAL",
        vs = "VISUAL(SELECT)",
        V = "V-LINE",
        Vs = "V-LINE(SELECT)",
        ["\22"] = "V-BLOCK",
        ["\22s"] = "V-BLOCK(SELECT)",

        s = "SELECT",
        S = "S-LINE",
        ["\19"] = "S-BLOCK",

        i = "INSERT",
        ic = "INSERT(COMPLETION)",
        ix = "INSERT(COMPLETION)",

        R = "REPLACE",
        Rc = "REPLACE(COMPLETION)",
        Rx = "REPLACE(COMPLETION)",
        Rv = "V-REPLACE",
        Rvc = "V-REPLACE(COMPLETION)",
        Rvx = "REPLACE(COMPLETION)",

        c = "COMMAND",
        cr = "COMMAND(REPLACE)",
        cv = "Ex",
        cvr = "Ex(INSERT)",

        r = "PROMPT",
        rm = "MORE",
        ["r?"] = "CONFIRM",
        ["!"] = "SHELL",
        t = "TERMINAL",
      },
      get_current_mode_hl = function(self)
        return self.mode_hls[self.shared.mode_name]
      end,
      shared = {},
      Mode,
      Git,
      Space,
      {
        condition = function()
          return not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = 0 }))
        end,
        event = {
          LspAttach = function() end,
          LspDetach = function() end,
        },
        update = function(self, events)
          for _, arg in ipairs(events) do
            if arg.event == "LspAttach" or arg.event == "LspDetach" then
              local names = {}
              for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
                table.insert(names, server.name)
              end
              self.status = " [" .. table.concat(names, " ") .. "] "
            end
          end
        end,
        provider = function(self)
          return self.status
        end,
        hl = { fg = colors.purple, bold = true },
      },
      Diagnostic,
      File,
      Algins,
      Space,
      Cursor,
    })
  end,
}
