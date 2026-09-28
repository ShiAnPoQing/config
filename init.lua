--- @class my
--- @field command my.command
--- @field keymap my.keymap
--- @field window my.window
--- @field multicursor my.multicursor
--- @field insert my.insert
--- @field operator my.operator
--- @field util my.util

--- @type my
_G.my = _G.my or {}
my._submodules = {
  command = true,
  keymap = true,
  window = true,
  multicursor = true,
  insert = true,
  operator = true,
  util = true,
}
setmetatable(my, {
  __index = function(t, key)
    if my._submodules[key] then
      t[key] = require("my." .. key)
      return t[key]
    end
  end,
})
my.window.float.drag.enable()

local wrap_opts = {
  enter = function()
    return { cursor = vim.api.nvim_win_get_cursor(0) }
  end,
  done = function(ctx)
    vim.api.nvim_win_set_cursor(0, ctx.cursor)
  end,
}
local wrap_opts2 = {
  enter = function()
    return { cursors = my.multicursor.get(0, 0, -1) }
  end,
  done = function(ctx)
    for _, c in ipairs(ctx.cursors) do
      vim.api.nvim_buf_set_extmark(0, vim.api.nvim_create_namespace("nvim.multicursor"), c[2], c[3], { id = c[1] })
    end
  end,
}

my.operator.wrap("gu", wrap_opts, wrap_opts2)
my.operator.wrap("gU", wrap_opts, wrap_opts2)
my.operator.wrap("g~", wrap_opts, wrap_opts2)
my.operator.wrap("y", wrap_opts, wrap_opts2)

do
  --- Visual cancel Cursor back
  local in_visual_mode
  local cursor
  vim.api.nvim_create_autocmd("ModeChanged", {
    callback = function(ev)
      local from, to = unpack(vim.split(ev.match, ":"))
      if not in_visual_mode then
        if vim.list_contains({ "V", "v", "" }, to) and from == "n" then
          in_visual_mode = true
          cursor = vim.api.nvim_win_get_cursor(0)
        end
      else
        if ev.match == "v:V" or ev.match == "V:v" then
          return
        end
        in_visual_mode = nil
        if vim.list_contains({ "V", "v", "" }, from) and to == "n" then
          vim.api.nvim_win_set_cursor(0, cursor)
          cursor = nil
        end
      end
    end,
  })
end

vim.pack.add({ { src = "https://github.com/BrokenSunny/native-packer", version = "branch" } })
require("command")
require("global")
require("option")
require("autocmds")
require("keymaps")
require("test")
require("native-packer").add({
  require("plugins.local.neo-lsp"),
  require("plugins.download.style"),
  require("plugins.download.style.statuscol"),
  require("plugins.download.style.lualine"),
  require("plugins.download.misc.nvim-navic"),
  require("plugins.local.native-macro"),
  require("plugins.download.misc.repeat"),
  require("plugins.local.native-diagnostic"),
  require("plugins.local.reasonable-scroll"),
  require("plugins.local.reasonable-screen-move"),
  require("plugins.local.window-swap"),
  require("plugins.local.buffer-swap"),
  require("plugins.download.misc.linefuse"),
  require("plugins.local.move-line"),
  require("plugins.local.move-word"),
  require("plugins.local.cursorline"),
  require("plugins.local.file-details"),
  require("plugins.download.misc.lazydev"),
  -- require("plugins.download.misc.zen"),
  require("plugins.download.git.gitsigns"),
  require("plugins.download.snippet.luasnip"),
  require("plugins.download.cmp.blink-cmp"),
  require("plugins.download.fzf"),
  require("plugins.download.format.conform"),
  require("plugins.download.treesitter"),
  require("plugins.download.filemanager.oil"),
  -- require("plugins.download.filemanager.neo-tree"),
  require("plugins.download.misc.autopairs"),
  require("plugins.download.misc.nvim-ts-autotag"),
  require("plugins.download.misc.supermaven"),
  require("plugins.download.misc.grug-far"),
  require("plugins.download.misc.toggleterm"),
  require("plugins.download.tmux.vim-tmux-navigator"),
  -- require("plugins.download.misc.todo-comments"),
  require("plugins.download.window.winshift"),
  -- require("plugins.download.misc.flash"),
  require("plugins.download.misc.snacks"),
  -- require("plugins.download.misc.trouble"),
  require("plugins.download.tex"),
  require("plugins.download.markdown"),
  require("plugins.download.misc.neotest"),
  -- require("plugins.download.misc.noice"),
  require("plugins.download.misc.outline"),
  require("plugins.download.misc.nvim-web-devicons"),
  require("plugins.local.test.treesitter-textobject"),
  require("plugins.local.test.eye-track-treesitter"),
  require("plugins.local.test.eye"),
  require("plugins.local.doc"),
  -- require("plugins.download.misc.ts-comments"),
  -- require("plugins.download.misc.persistence"),
  -- require("plugins.download.misc.showkey"),
  require("plugins.download.misc.screenkey"),
  require("plugins.download.mini"),
  require("plugins.download.filemanager.yazi"),
  require("plugins.download.misc.misc"),
  -- require("plugins.download.ai.copilot"),
  require("plugins.local.test.bufferman"),
  -- require("plugins.download.ai.opencode"),
  require("plugins.local.test.lsp-layer"),
  -- require("plugins.test.pulseline"),
  -- require("plugins.local.shell-connect"),
  -- require("plugins.test.luma"),
  require("plugins.test.ring"),
  require("plugins.test.window-resize"),
  require("plugins.test._eye"),
  require("plugins.builtin"),
  require("plugins.test.command-proxy"),
  require("plugins.local.native-dir"),
  -- require("plugins.local.neo-tagstack"),
  -- require("plugins.local.visual-move"),
  -- require("plugins.local.bufferman"),
  -- require("plugins.local.test.statusline"),
  -- require("plugins.local.op-register"),
  -- require("plugins.local.simple-translate"),
  -- require("plugins.local.neo-winbar"),
  -- require("plugins.local.test.eye-track"),
})

-- local width = 4
-- local height = 2
-- local buf = vim.api.nvim_create_buf(false, true)
-- local win = vim.api.nvim_open_win(buf, true, {
--   relative = "editor",
--   width = width,
--   height = height,
--   row = 0,
--   col = 0,
--   style = "minimal",
--   border = "single",
-- })
-- --
-- -- vim.keymap.set("n", "<M-l>", function()
-- --   M.move(win, 0, 1)
-- -- end, { buf = buf })
-- -- vim.keymap.set("n", "<M-h>", function()
-- --   M.move(win, 0, -1)
-- -- end, { buf = buf })
-- -- vim.keymap.set("n", "<M-k>", function()
-- --   M.move(win, -1, 0)
-- end, { buf = buf })
-- -- vim.keymap.set("n", "<M-j>", function()
-- --   M.move(win, 1, 0)
-- -- end, { buf = buf })
