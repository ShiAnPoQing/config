local M = {}

function M.setup()
  vim.o.complete = ".,o"
  vim.o.completeopt = "fuzzy,noselect,menu,popup"
  vim.o.autocomplete = true
  vim.o.pumheight = 15

  vim.o.wildmode = "noselect:lastused,full"
  vim.o.wildoptions = "pum,fuzzy"
  vim.api.nvim_create_autocmd("CmdlineChanged", {
    pattern = "[:/\\?]",
    callback = function()
      vim.fn.wildtrigger()
    end,
  })

  vim.api.nvim_create_autocmd("CompleteDone", {
    callback = function()
      local completed = vim.v.completed_item
      if
        completed
        and completed.user_data
        and completed.user_data.nvim
        and completed.user_data.nvim.lsp
        and completed.user_data.nvim.lsp.completion_item
        and completed.kind == "Snippet"
      then
        local insert_text = completed.user_data.nvim.lsp.completion_item.insertText
        if type(insert_text) == "string" then
          -- local line = vim.api.nvim_get_current_line()
          -- vim.api.nvim_set_current_line()
          vim.snippet.expand(insert_text)
        end
      end
    end,
  })
end

return M
