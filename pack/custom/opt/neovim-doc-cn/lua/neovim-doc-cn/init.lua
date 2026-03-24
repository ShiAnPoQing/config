local M = {}

function M.setup(options)
  vim.api.nvim_create_user_command("NeovimDocCNUpdateTags", function()
    require("neovim-doc-cn.tag").update()
  end, {})
end

return M
