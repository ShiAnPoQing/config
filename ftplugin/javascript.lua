require("native-packer.key").add({
  ["<leader>js"] = {
    function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "nx", true)
      local start_row = unpack(vim.api.nvim_buf_get_mark(0, "<"))
      local end_row = unpack(vim.api.nvim_buf_get_mark(0, ">"))
      local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
      local line = table.concat(lines, "\n")
      vim.system({
        "node",
        "-e",
        line,
      }, { text = true }, function(out)
        vim.schedule(function()
          if out.code == 0 then
            vim.api.nvim_echo({ { out.stdout, "Normal" } }, true, {})
          elseif out.code == 1 then
            vim.api.nvim_echo({ { out.stderr, "Error" } }, true, {})
          end
        end)
      end)
    end,
    "x",
    desc = "NodeJS execute visual lines",
    buffer = true,
  },
})
