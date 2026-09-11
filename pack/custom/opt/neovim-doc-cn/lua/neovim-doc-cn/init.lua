local M = {}

function M.setup()
  vim.api.nvim_create_user_command("NeovimDocUpdateTags", function()
    require("neovim-doc-cn.tag").update()
  end, {})
end

return M
