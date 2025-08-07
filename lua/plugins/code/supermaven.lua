return {
  "supermaven-inc/supermaven-nvim",
  event = "BufEnter",
  config = function()
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<C-g>",
        clear_suggestion = "<C-x>",
        accept_word = "<C-;>",
      },
    })
  end,
}
