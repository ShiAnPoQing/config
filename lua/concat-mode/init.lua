local save_maps;
local custom_maps = { "<M-j>", "<Esc>" }

local function createFloatWin(winId, title)
  local win_height = vim.api.nvim_win_get_height(winId)
  local float_bufnr = vim.api.nvim_create_buf(false, true)

  local message = " " .. title
  vim.api.nvim_buf_set_lines(float_bufnr, 0, -1, false, { message })

  local win_config = {
    relative = "win", -- 相对于指定的窗口
    win = winId,      -- 指定相对的窗口ID
    width = 13,       -- 浮动窗口的宽度
    height = 1,       -- 浮动窗口的高度
    row = win_height - 3,
    col = 0,
    style = "minimal", -- 最小化样式
    noautocmd = true,  -- 禁用自动命令
    focusable = false,
    border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" }
  }

  local float_win = vim.api.nvim_open_win(float_bufnr, false, win_config)
  vim.api.nvim_win_set_option(float_win, "winhl", "Normal:MyFloatWin")
  vim.api.nvim_buf_set_option(float_bufnr, "modifiable", false)
  vim.api.nvim_buf_set_option(float_bufnr, "readonly", true)

  return float_win
end

vim.api.nvim_create_user_command("ConcatMode", function(opts)
  local maps = vim.api.nvim_get_keymap("n")

  if not save_maps then
    save_maps = {}
    for _, map in ipairs(maps) do
      if vim.tbl_contains(custom_maps, map.lhs) then
        save_maps[map.lhs] = map
      end
    end
  end

  vim.api.nvim_set_hl(0, "MyFloatWin", { fg = "#8A2BE2" })
  local id = vim.api.nvim_get_current_win()
  local float_win_id = createFloatWin(id, "Concat Mode")

  require("plugin-keymap").add({
    ["<M-j>"] = {
      "J",
      "n",
      { buffer = true }
    },
    ["<Esc>"] = {
      function()
        for _, lhs in ipairs(custom_maps) do
          local map = save_maps[lhs]
          pcall(vim.keymap.del, "n", lhs)

          if map then
            vim.keymap.set("n", lhs, map.rhs, { noremap = map.noremap == 1, silent = map.silent == 1 })
          end
        end

        vim.api.nvim_win_close(float_win_id, true)
      end,
      "n",
      { buffer = true }
    }
  })
end, {})
