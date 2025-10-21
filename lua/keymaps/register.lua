return {
  ["<leader>crg"] = {
    function()
      vim.ui.input({
        prompt = "Clear register: ",
      }, function(input)
        if input then
          local reg_str = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"'
          local regs = {}
          local clear_regs = {}
          for c in reg_str:gmatch(".") do
            table.insert(regs, c)
          end
          for c in input:gmatch(".") do
            table.insert(clear_regs, c)
          end

          for _, value in ipairs(clear_regs) do
            if vim.list_contains(regs, value) then
              vim.fn.setreg(value, "")
            end
          end
        end
      end)
    end,
    "n",
    desc = "Clear registers",
  },
}
