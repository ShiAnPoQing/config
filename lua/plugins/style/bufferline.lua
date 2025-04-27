return {
  "akinsho/bufferline.nvim",
  lazy = false,
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local bufferline = require("bufferline")
    bufferline.setup({
      options = {
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          return "(" .. count .. ")"
        end,
        right_mouse_command = "vertical sbuffer %d",
        close_command = function(bufnum)
          require("bufdelete").bufdelete(bufnum, true)
        end,
        indicator = {
          icon = "", -- this should be omitted if indicator style is not 'icon'
          style = "underline",
        },
        always_show_bufferline = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    })
    require("parse-keymap").addKeymap({
      ["<leader>bp"] = {
        "<cmd>BufferLineTogglePin<cr>",
        "n",
        { desc = "Toggle Pin" },
      },
      ["<leader>bP"] = {
        "<cmd>BufferLineGroupClose ungrouped<cr>",
        "n",
        { desc = "Delete Non-Pinned Buffers" },
      },
      ["<leader>bo"] = {
        "<cmd>BufferLineCloseOthers<cr>",
        "n",
        { desc = "Delete Other Buffers" },
      },
      ["<leader>br"] = {
        "<cmd>BufferLineCloseRight<cr>",
        "n",
        { desc = "Delete Buffers to the Right" },
      },
      ["<leader>bl"] = {
        "<cmd>BufferLineCloseLeft<cr>",
        "n",
        { desc = "Delete Buffers to the Left" },
      },
      ["<Tab><Tab>j"] = {
        "<cmd>BufferLineMoveNext<cr>",
        "n",
        { desc = "Move buffer next" },
      },
      ["<Tab><Tab>k"] = {
        "<cmd>BufferLineMovePrev<cr>",
        "n",
        { desc = "Move buffer previous" },
      },
      ["<Tab>k"] = {
        "<cmd>BufferLineCyclePrev<cr>",
        "n",
        { desc = "Prev buffer" },
      },
      ["<Tab>j"] = {
        "<cmd>BufferLineCycleNext<cr>",
        "n",
        { desc = "Next buffer" },
      },
      ["<Tab><Tab>h"] = {
        function()
          bufferline.move_to(1)
        end,
        "n",
        { desc = "Move buffer Far left" },
      },
      ["<Tab><Tab>l"] = {
        function()
          bufferline.move_to(-1)
        end,
        "n",
        { desc = "Move buffer Far right" },
      },
      ["<Tab>f"] = {
        "<cmd>BufferLinePick<cr>",
        "n",
        { desc = "Pick buffer" }
      },
      ["<Tab>1"] = { "<Cmd>BufferLineGoToBuffer 1<CR>", "n" },
      ["<Tab>2"] = { "<Cmd>BufferLineGoToBuffer 2<CR>", "n" },
      ["<Tab>3"] = { "<Cmd>BufferLineGoToBuffer 3<CR>", "n" },
      ["<Tab>4"] = { "<Cmd>BufferLineGoToBuffer 4<CR>", "n" },
      ["<Tab>5"] = { "<Cmd>BufferLineGoToBuffer 5<CR>", "n" },
      ["<Tab>6"] = { "<Cmd>BufferLineGoToBuffer 6<CR>", "n" },
      ["<Tab>7"] = { "<Cmd>BufferLineGoToBuffer 7<CR>", "n" },
      ["<Tab>8"] = { "<Cmd>BufferLineGoToBuffer 8<CR>", "n" },
      ["<Tab>9"] = { "<Cmd>BufferLineGoToBuffer 9<CR>", "n" },
      ["<Tab>0"] = { "<Cmd>BufferLineGoToBuffer -1<CR>", "n" },
    })
  end,
}
