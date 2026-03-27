return {
  name = "native-diagnostic.nvim",
  event = "BufReadPost",
  depend = {
    "BrokenSunny/repeat.nvim",
    "MunifTanjim/nui.nvim",
  },
  key = {
    ["<leader>de"] = {
      function()
        vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = 0 }), { bufnr = 0 })
      end,
      "n",
    },
    ["<leader>da"] = {
      function()
        vim.diagnostic.setloclist()
      end,
      "n",
      desc = "Show diagnostic in location list",
    },
    ["<leader>dq"] = {
      function()
        vim.diagnostic.setqflist()
      end,
      "n",
      desc = "Show diagnostic in quickfix list",
    },
    ["<leader>df"] = {
      function()
        vim.diagnostic.open_float({})
      end,
      "n",
    },
    ["[h"] = {
      function()
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.HINT, count = -1 })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto prev HINT diagnostic",
    },
    ["]h"] = {
      function()
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.HINT, count = 1 })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto next HINT diagnostic",
    },
    ["[H"] = {
      function()
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.HINT, count = -vim._maxint })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto prev HINT diagnostic",
    },
    ["]H"] = {
      function()
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.HINT, count = vim._maxint })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto next HINT diagnostic",
    },
    ["{h"] = {
      function()
        local on_jump = require("native-diagnostic.jump").alternate
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.HINT, count = -1, on_jump = on_jump })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto prev HINT diagnostic",
    },
    ["}h"] = {
      function()
        local on_jump = require("native-diagnostic.jump").alternate
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.HINT, count = 1, on_jump = on_jump })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto next HINT diagnostic",
    },
    ["{H"] = {
      function()
        local on_jump = require("native-diagnostic.jump").alternate
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.HINT, count = -vim._maxint, on_jump = on_jump })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto prev HINT diagnostic",
    },
    ["}H"] = {
      function()
        local on_jump = require("native-diagnostic.jump").alternate
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.HINT, count = vim._maxint, on_jump = on_jump })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto next INFO diagnostic",
    },
    ["[i"] = {
      function()
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.INFO, count = -1 })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto prev INFO diagnostic",
    },
    ["]i"] = {
      function()
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.INFO, count = 1 })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto next INFO diagnostic",
    },
    ["[I"] = {
      function()
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.INFO, count = -vim._maxint })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto prev INFO diagnostic",
    },
    ["]I"] = {
      function()
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.INFO, count = vim._maxint })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto next INFO diagnostic",
    },
    ["{i"] = {
      function()
        local on_jump = require("native-diagnostic.jump").alternate
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.INFO, count = -1, on_jump = on_jump })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto prev INFO diagnostic",
    },
    ["}i"] = {
      function()
        local on_jump = require("native-diagnostic.jump").alternate
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.INFO, count = 1, on_jump = on_jump })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto next INFO diagnostic",
    },
    ["{I"] = {
      function()
        local on_jump = require("native-diagnostic.jump").alternate
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.INFO, count = -vim._maxint, on_jump = on_jump })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto prev INFO diagnostic",
    },
    ["}I"] = {
      function()
        local on_jump = require("native-diagnostic.jump").alternate
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.INFO, count = vim._maxint, on_jump = on_jump })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto next INFO diagnostic",
    },
    ["[w"] = {
      function()
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.WARN, count = -1 })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto prev WARN diagnostic",
    },
    ["]w"] = {
      function()
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.WARN, count = 1 })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto next WARN diagnostic",
    },
    ["[W"] = {
      function()
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.WARN, count = -vim._maxint })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto prev WARN diagnostic",
    },
    ["]W"] = {
      function()
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.WARN, count = vim._maxint })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto next WARN diagnostic",
    },
    ["{w"] = {
      function()
        local on_jump = require("native-diagnostic.jump").alternate
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.WARN, count = -1, on_jump = on_jump })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto prev WARN diagnostic",
    },
    ["}w"] = {
      function()
        local on_jump = require("native-diagnostic.jump").alternate
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.WARN, count = 1, on_jump = on_jump })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto next WARN diagnostic",
    },
    ["{W"] = {
      function()
        local on_jump = require("native-diagnostic.jump").alternate
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.WARN, count = -vim._maxint, on_jump = on_jump })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto prev WARN diagnostic",
    },
    ["}W"] = {
      function()
        local on_jump = require("native-diagnostic.jump").alternate
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.WARN, count = vim._maxint, on_jump = on_jump })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto next WARN diagnostic",
    },
    ["]e"] = {
      function()
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = 1 })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto next error diagnostic",
    },
    ["[e"] = {
      function()
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = -1 })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto prev ERROR diagnostic",
    },
    ["[E"] = {
      function()
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = -vim._maxint })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto prev ERROR diagnostic",
    },
    ["]E"] = {
      function()
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = vim._maxint })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto next error diagnostic",
    },
    ["}e"] = {
      function()
        local on_jump = require("native-diagnostic.jump").alternate
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = 1, on_jump = on_jump })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto next error diagnostic",
    },
    ["{e"] = {
      function()
        local on_jump = require("native-diagnostic.jump").alternate
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = -1, on_jump = on_jump })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto prev ERROR diagnostic",
    },
    ["{E"] = {
      function()
        local on_jump = require("native-diagnostic.jump").alternate
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = -vim._maxint, on_jump = on_jump })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto prev ERROR diagnostic",
    },
    ["}E"] = {
      function()
        local on_jump = require("native-diagnostic.jump").alternate
        local function callback()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = vim._maxint, on_jump = on_jump })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto next error diagnostic",
    },
    ["[d"] = {
      function()
        local function callback()
          vim.diagnostic.jump({ count = -vim.v.count1 })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto prev diagnostic",
    },
    ["]d"] = {
      function()
        local function callback()
          vim.diagnostic.jump({ count = vim.v.count1 })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto next diagnostic",
    },
    ["]D"] = {
      function()
        local function callback()
          vim.diagnostic.jump({ count = vim._maxint, wrap = false })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto last diagnostic",
    },
    ["[D"] = {
      function()
        local function callback()
          vim.diagnostic.jump({ count = -vim._maxint, wrap = false })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto first diagnostic",
    },
    ["{d"] = {
      function()
        local on_jump = require("native-diagnostic.jump").alternate
        local function callback()
          vim.diagnostic.jump({ count = -vim.v.count1, on_jump = on_jump })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto prev diagnostic",
    },
    ["}d"] = {
      function()
        local function callback()
          local on_jump = require("native-diagnostic.jump").alternate
          vim.diagnostic.jump({ count = vim.v.count1, on_jump = on_jump })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto next diagnostic",
    },
    ["}D"] = {
      function()
        local on_jump = require("native-diagnostic.jump").alternate
        local function callback()
          vim.diagnostic.jump({ count = vim._maxint, wrap = false, on_jump = on_jump })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto last diagnostic",
    },
    ["{D"] = {
      function()
        local on_jump = require("native-diagnostic.jump").alternate
        local function callback()
          vim.diagnostic.jump({ count = -vim._maxint, wrap = false, on_jump = on_jump })
          vim.api.nvim_feedkeys("zz", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
      desc = "Goto first diagnostic",
    },
    ["scd"] = {
      function()
        require("native-diagnostic").choose()
      end,
      "n",
      desc = "Choose diagnostic style",
    },
  },
  config = function()
    require("native-diagnostic").setup()
  end,
}
