function _G.get_oil_winbar()
  local dir = require("oil").get_current_dir()
  if dir then
    return vim.fn.fnamemodify(dir, ":~")
  else
    return vim.api.nvim_buf_get_name(0)
  end
end

return {
  "stevearc/oil.nvim",
  dependencies = { "echasnovski/mini.icons" },
  keys = {
    { "<leader>oi", "<cmd>Oil<cr>" },
  },
  config = function()
    require("oil").setup({
      win_options = {
        winbar = "%!v:lua.get_oil_winbar()",
      },
    })
  end,
}
