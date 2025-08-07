return {
  [";tm"] = {
    {
      function()
        local T = require("text-align")
        T.textAlign({
          align = "middle",
          mode = "n",
        })
        require("repeat").Record(function()
          T.textAlign({
            align = "middle",
            mode = "n",
          })
        end)
      end,
      "n",
    },
    {
      function()
        local T = require("text-align")
        T.textAlign({
          align = "middle",
          mode = "v",
        })
        require("repeat").Record(function()
          T.textAlign({
            align = "middle",
            mode = "v",
          })
        end)
      end,
      "x",
    },
  },
  [";tl"] = {
    {
      function()
        local T = require("text-align")
        T.textAlign({
          align = "right",
          mode = "n",
        })
        require("repeat").Record(function()
          T.textAlign({
            align = "right",
            mode = "n",
          })
        end)
      end,
      "n",
    },
    {
      function()
        local T = require("text-align")
        T.textAlign({
          align = "right",
          mode = "v",
        })
        require("repeat").Record(function()
          T.textAlign({
            align = "right",
            mode = "v",
          })
        end)
      end,
      "x",
    },
  },
  [";th"] = {
    {
      function()
        local T = require("text-align")
        T.textAlign({
          align = "left",
          mode = "n",
        })
        require("repeat").Record(function()
          T.textAlign({
            align = "left",
            mode = "n",
          })
        end)
      end,
      "n",
    },
    {
      function()
        local T = require("text-align")
        T.textAlign({
          align = "left",
          mode = "v",
        })
        require("repeat").Record(function()
          T.textAlign({
            align = "left",
            mode = "v",
          })
        end)
      end,
      "x",
    },
  },
}
