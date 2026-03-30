return {
  name = "gaze.nvim",
  key = {
    ["<leader>7"] = {
      function()
        require("gaze.group.root"):new({
          {
            buf = 1,
            label = {},
            layer = {},
            {
              items = {},
              data = {},
            },
            {
              items = {},
              data = {},
            },
          },
          {
            buf = 2,
            label = {},
            layer = {},
            {
              label = {},
              layer = {},
              {
                items = {},
                data = {},
              },
              {
                items = {},
                data = {},
              },
            },
            {
              items = {},
              data = {},
            },
          },
          label = {
            extmark = {},
            highlight = {},
          },
          layer = {},
          start = function() end,
          finish = function() end,
        })
      end,
      "n",
    },
  },
  config = function() end,
}
