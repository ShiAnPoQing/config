return {
  "supermaven-inc/supermaven-nvim",
  event = "InsertEnter",
  config = function()
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<C-g>",
        -- clear_suggestion = "<C-x>",
        accept_word = "<C-;>",
      },
      condition = function()
        local filetype = vim.bo.filetype
        if vim.startswith(filetype, "neo-tree") then
          return true
        end
        return false
      end,
    })
  end,
}
