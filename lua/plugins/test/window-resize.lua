return {
  name = "window-resize.nvim",
  key = {
    ["<M-down>"] = {
      function()
        require("window-resize").resize({
          bottom = 1,
        })
      end,
      "n",
      desc = "Increase window height[bottom]",
    },
    ["<M-Space><M-down>"] = {
      function()
        require("window-resize").resize({
          bottom = 1000,
        })
      end,
      "n",
      desc = "Drag window bottom to the far bottom",
    },
    ["<M-up>"] = {
      function()
        require("window-resize").resize({
          bottom = -1,
        })
      end,
      "n",
      desc = "Decrease window height[bottom]",
    },
    ["<M-Space><M-up>"] = {
      function()
        require("window-resize").resize({
          bottom = -1000,
        })
      end,
      "n",
      desc = "Drag window bottom to the far top",
    },
    ["<C-down>"] = {
      function()
        require("window-resize").resize({
          top = -1,
        })
      end,
      "n",
      desc = "Decrease window height[top]",
    },
    ["<C-Space><C-down>"] = {
      function()
        require("window-resize").resize({
          top = -1000,
        })
      end,
      "n",
      desc = "Drag window top to the far bottom",
    },
    ["<C-up>"] = {
      function()
        require("window-resize").resize({
          top = 1,
        })
      end,
      "n",
      desc = "Increase window height[top]",
    },
    ["<C-Space><C-up>"] = {
      function()
        require("window-resize").resize({
          top = 1000,
        })
      end,
      "n",
      desc = "Drag window top to the far top",
    },
    ["<M-left>"] = {
      function()
        require("window-resize").resize({
          right = -1,
        })
      end,
      "n",
      desc = "Decrease window width[right]",
    },
    ["<M-Space><M-left>"] = {
      function()
        require("window-resize").resize({
          right = -1000,
        })
      end,
      "n",
      desc = "Drag window right to the far left",
    },
    ["<C-left>"] = {
      function()
        require("window-resize").resize({
          left = 1,
        })
      end,
      "n",
      desc = "Increase window width[left]",
    },
    ["<C-Space><C-left>"] = {
      function()
        require("window-resize").resize({
          left = 1000,
        })
      end,
      "n",
      desc = "Drag window left to the far left",
    },
    ["<M-right>"] = {
      function()
        require("window-resize").resize({
          right = 1,
        })
      end,
      "n",
      desc = "Increase window width[right]",
    },
    ["<M-Space><M-right>"] = {
      function()
        require("window-resize").resize({
          right = 1000,
        })
      end,
      "n",
      desc = "Drag window right to the far right",
    },
    ["<C-right>"] = {
      function()
        require("window-resize").resize({
          left = -1,
        })
      end,
      "n",
      desc = "Decrease window width[left]",
    },
    ["<C-Space><C-right>"] = {
      function()
        require("window-resize").resize({
          left = -1000,
        })
      end,
      "n",
      desc = "Drag window left to the far right",
    },
    -- ["<M-C-up>"] = {
    --   function()
    --     require("window-resize").resize({
    --       top = 1,
    --       bottom = 1,
    --     })
    --   end,
    --   "n",
    --   desc = "Increase window height[top&bottom]",
    -- },
    -- ["<M-C-down>"] = {
    --   function()
    --     require("window-resize").resize({
    --       top = -1,
    --       bottom = -1,
    --     })
    --   end,
    --   "n",
    --   desc = "Decrease window height[top&bottom]",
    -- },
    ["<M-C-=>"] = {
      function()
        require("window-resize").resize({
          right = 1,
          left = 1,
        })
      end,
      "n",
      desc = "Increase window width[left&right]",
    },
    ["<M-C-->"] = {
      function()
        require("window-resize").resize({
          right = -1,
          left = -1,
        })
      end,
      "n",
      desc = "Decrease window width[left&right]",
    },
    ["<M-C-S-=>"] = {
      function()
        require("window-resize").resize({
          top = 1,
          bottom = 1,
          left = 2,
          right = 2,
        })
      end,
      "n",
      desc = "Increase window size",
    },
    ["<M-C-S-->"] = {
      function()
        require("window-resize").resize({
          top = -1,
          bottom = -1,
          left = -2,
          right = -2,
        })
      end,
      desc = "Decrease window size",
      "n",
    },
    ["<M-C-right>"] = {
      function()
        require("window-resize").resize({
          right = 1,
          left = -1,
        })
      end,
      "n",
      desc = "Move window to the right",
    },
    ["<M-C-left>"] = {
      function()
        require("window-resize").resize({
          right = -1,
          left = 1,
        })
      end,
      "n",
      desc = "Move window to the left",
    },
    ["<M-C-up>"] = {
      function()
        require("window-resize").resize({
          top = 1,
          bottom = -1,
        })
      end,
      "n",
      desc = "Move window to the up",
    },
    ["<M-C-down>"] = {
      function()
        require("window-resize").resize({
          top = -1,
          bottom = 1,
        })
      end,
      "n",
      desc = "Move window to the down",
    },
  },
}
