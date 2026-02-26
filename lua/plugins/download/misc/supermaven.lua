return {
  "supermaven-inc/supermaven-nvim",
  event = "InsertEnter",
  config = function()
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<C-\\>",
        clear_suggestion = "<C-Space><C-\\>",
        accept_word = "<M-\\>",
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
