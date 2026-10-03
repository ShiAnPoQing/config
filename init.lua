--- @class my
--- @field command my.command
--- @field keymap my.keymap
--- @field window my.window
--- @field multicursor my.multicursor
--- @field insert my.insert
--- @field operator my.operator
--- @field motion my.motion
--- @field cursor my.cursor
--- @field util my.util
--- @field g my.g
--- @field b my.b
--- @field w my.w
--- @field t my.t

--- @class my.g: { [string]: any }
--- @class my.b: vim.var_accessor
--- @class my.w: vim.var_accessor
--- @class my.t: vim.var_accessor

--- @type my
_G.my = _G.my or {}
my._submodules = {
  command = true,
  keymap = true,
  window = true,
  multicursor = true,
  cursor = true,
  insert = true,
  operator = true,
  motion = true,
  util = true,
}

do
  --- @param scope string
  --- @param handle? false|integer
  --- @return vim.var_accessor
  local function make_dict_accessor(scope, handle)
    vim.validate("scope", scope, "string")
    local mt = {}
    --- @param k string
    --- @param v any
    function mt.__newindex(_, k, v)
      if handle then
        local vars = vim[scope][handle].my or {}
        vars[k] = v
        vim[scope][handle].my = vars
      else
        local vars = vim[scope].my or {}
        vars[k] = v
        vim[scope].my = vars
      end
    end
    --- @param k string|integer
    function mt.__index(_, k)
      if handle == nil and type(k) == "number" then
        return make_dict_accessor(scope, k)
      end
      if handle then
        if vim[scope][handle].my == nil then
          return nil
        end
        return vim[scope][handle].my[k]
      else
        if vim[scope].my == nil then
          return nil
        end
        return vim[scope].my[k]
      end
    end
    return setmetatable({}, mt)
  end

  my.g = make_dict_accessor("g", false)
  my.b = make_dict_accessor("b")
  my.w = make_dict_accessor("w")
  my.t = make_dict_accessor("t")
end

do
  --- @param exec string|fun()
  function my.searchdo(exec)
    local mode = vim.api.nvim_get_mode().mode
    local ctx = {}
    if mode == "V" then
      vim.cmd("normal! V")
      ctx.topline = vim.api.nvim_buf_get_mark(0, "<")[1]
      ctx.botline = vim.api.nvim_buf_get_mark(0, ">")[1]
      local visual_ns = vim.api.nvim_create_namespace("my.search")
      vim.api.nvim_buf_set_extmark(0, visual_ns, ctx.topline - 1, 0, {
        hl_group = "Visual",
        end_row = ctx.botline,
        end_col = 0,
      })
      ctx.cleanup = function()
        vim.api.nvim_buf_clear_namespace(0, visual_ns, 0, -1)
      end
      ctx.matched = function(matches)
        local cursor = vim.api.nvim_win_get_cursor(0)
        local final_cursor
        local first_extmark_id
        for i, m in ipairs(matches) do
          if not final_cursor and ((m.line == cursor[1] and m.col >= cursor[2]) or m.line > cursor[1]) then
            final_cursor = { m.line, m.col }
          else
            local id = vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, m.line - 1, m.col, {})
            if i == 1 then
              first_extmark_id = id
            end
          end
        end

        if final_cursor then
          vim.api.nvim_win_set_cursor(0, final_cursor)
          return
        end

        if #matches == 0 then
          return
        end
        vim.api.nvim_win_set_cursor(0, { matches[1].line, matches[1].col })
        vim.api.nvim_buf_del_extmark(0, my.multicursor.ns, first_extmark_id)
      end
    elseif mode == "n" then
      ctx.topline = 1
      ctx.botline = vim.api.nvim_buf_line_count(0)
      ctx.matched = function(matches)
        vim.api.nvim_feedkeys("n", "nx", false)
        local cursor = vim.api.nvim_win_get_cursor(0)
        for _, m in ipairs(matches) do
          if not (m.line == cursor[1] and m.col == cursor[2]) then
            vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, m.line - 1, m.col, {})
          end
        end
      end
      ctx.exec = function()
        if type(exec) == "string" then
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(exec, true, false, true), "nt", false)
        end
      end
    end
    local buf = vim.api.nvim_get_current_buf()
    local prev_matches = {}
    local function step(pattern)
      local char = vim.fn.getchar(-1, { number = false })
      char = type(char) == "string" and vim.fn.keytrans(char) or ""
      if char == "<Esc>" then
        my.util.try(ctx.cleanup)
        return
      end
      if char == "<CR>" then
        my.util.try(ctx.matched, prev_matches)
        my.util.try(ctx.exec)
        my.util.try(ctx.cleanup)
        return
      end
      pattern = pattern .. char
      local regex = vim.regex(pattern)
      local matches = {}
      for i = ctx.topline, ctx.botline do
        local start_pos = 0
        while true do
          local start, end_ = regex:match_line(buf, i - 1, start_pos)
          if not start or not end_ or (start == 0 and end_ == 0) then
            break
          end
          table.insert(matches, { line = i, col = start + start_pos, end_col = end_ + start_pos })
          start_pos = start_pos + end_
        end
      end
      prev_matches = matches
      vim.o.hlsearch = true
      vim.fn.setreg("/", pattern)
      vim.cmd.redraw()
      vim.api.nvim_echo({ { "/" .. pattern, "Normal" } }, false)

      step(pattern)
    end
    step("")
  end
end

setmetatable(my, {
  __index = function(t, key)
    if my._submodules[key] then
      t[key] = require("my." .. key)
      return t[key]
    end
  end,
})
my.window.float.drag.enable()

do
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
        vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, c[2], c[3], { id = c[1] })
      end
    end,
  }

  my.operator.wrap("gu", wrap_opts, wrap_opts2)
  my.operator.wrap("gU", wrap_opts, wrap_opts2)
  my.operator.wrap("g~", wrap_opts, wrap_opts2)
  my.operator.wrap("y", wrap_opts, wrap_opts2)
end

-- vim.api.nvim_create_user_command("Mc", function(ev)
--   local args = ev.args
--   local regex = vim.regex(args)
--   local total = vim.api.nvim_buf_line_count(0)
--   local matches = {}
--   local buf = vim.api.nvim_get_current_buf()
--   for i = 1, total do
--     local start_pos = 0
--     while true do
--       local start, end_ = regex:match_line(buf, i - 1, start_pos)
--       if not start or not end_ or (start == 0 and end_ == 0) then
--         break
--       end
--       table.insert(matches, { line = i, col = start + start_pos, end_col = end_ + start_pos })
--       start_pos = start_pos + end_
--     end
--   end
--   for _, m in ipairs(matches) do
--     vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, m.line - 1, m.col, {})
--   end
-- end, {
--   nargs = "*",
-- })

do
  -- Visual cancel Cursor back
  local in_visual_mode
  local changed_tick
  local cursor
  vim.api.nvim_create_autocmd("ModeChanged", {
    callback = function(ev)
      local from, to = unpack(vim.split(ev.match, ":"))
      if not in_visual_mode then
        if vim.list_contains({ "V", "v", "" }, to) and from == "n" then
          in_visual_mode = true
          changed_tick = vim.api.nvim_buf_get_changedtick(0)
          cursor = vim.api.nvim_win_get_cursor(0)
        end
        return
      end

      if ev.match == "v:V" or ev.match == "V:v" then
        return
      end
      if
        vim.list_contains({ "V", "v", "" }, from)
        and to == "n"
        and changed_tick == vim.api.nvim_buf_get_changedtick(0)
      then
        pcall(vim.api.nvim_win_set_cursor, 0, cursor)
      end
      cursor = nil
      in_visual_mode = nil
      changed_tick = nil
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

vim.keymap.set("n", "m/", function()
  local ns = vim.api.nvim_create_namespace("my.search")
  vim.on_key(function(key)
    local input = vim.fn.keytrans(key)
    if input == "<CR>" then
      vim.schedule(function()
        vim.on_key(nil, ns)
        local pattern = vim.fn.getreg("/")
        local cursor = vim.api.nvim_win_get_cursor(0)
        local regex = vim.regex(pattern)
        local total = vim.api.nvim_buf_line_count(0)
        local matches = {}
        local buf = vim.api.nvim_get_current_buf()
        for i = 1, total do
          local start_pos = 0
          while true do
            local start, end_ = regex:match_line(buf, i - 1, start_pos)
            if not start or not end_ or (start == 0 and end_ == 0) then
              break
            end
            table.insert(matches, { line = i, col = start + start_pos, end_col = end_ + start_pos })
            start_pos = start_pos + end_
          end
        end
        for _, m in ipairs(matches) do
          if m.line == cursor[1] and m.col == cursor[2] then
          else
            vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, m.line - 1, m.col, {})
          end
        end
        vim.bo.follow = true
      end)
    end
  end, ns)
  vim.api.nvim_feedkeys("/", "n", true)
end)

vim.keymap.set("n", "<F6>", "xw")
