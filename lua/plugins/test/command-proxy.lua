return {
  name = "command-proxy.nvim",
  event = "CmdlineEnter",
  config = function()
    local function cmd_to_reg(cmd)
      if vim.v.register ~= "+" then
        local output = vim.api.nvim_exec2(cmd, { output = true }).output
        vim.fn.setreg(vim.v.register, output)
      end
    end

    local function eye_buffer()
      local curr_win = vim.api.nvim_get_current_win()
      local curr_buf = vim.api.nvim_get_current_buf()

      local buftype = vim.api.nvim_get_option_value("buftype", {
        buf = curr_buf,
      })
      if buftype == "help" then
        return
      end

      local buf = vim.api.nvim_create_buf(false, true)
      local bufs = {}
      local lines = {}
      local labels = {}
      local curr_buf_row
      local maxlen = 0
      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_get_option_value("buflisted", {
          buf = b,
        }) then
          local bufname = vim.api.nvim_buf_get_name(b)
          bufname = vim.fn.fnamemodify(bufname, ":p:.")
          if bufname == "" then
            bufname = "[[No Name]]"
          end
          local line = "#" .. b .. " " .. bufname
          maxlen = math.max(maxlen, #line)
          table.insert(lines, line)
          table.insert(bufs, b)
          if b ~= curr_buf then
            table.insert(labels, {
              buf = buf,
              row = #bufs,
              col = 0,
              bufnr = b,
            })
          else
            curr_buf_row = #bufs
          end
        end
      end
      if #bufs == 1 then
        return
      end

      vim.api.nvim_set_hl(0, "BorderUnderline", { underline = true })
      vim.api.nvim_set_hl(0, "BorderOverline", { overline = true })
      local FloatTitle = vim.api.nvim_get_hl(0, {
        name = "FloatTitle",
        link = false,
      })
      vim.api.nvim_set_hl(0, "FloatTitleOverline", { overline = true, fg = FloatTitle.fg, bold = true })
      local win = vim.api.nvim_open_win(buf, false, {
        relative = "laststatus",
        height = #bufs,
        width = 10000,
        col = 2,
        row = -#bufs - (vim.o.laststatus == 3 and 1 or 0) - 1,
        title = "▶buffer◀",
        title_pos = "center",
        noautocmd = true,
        border = {
          { " ", "BorderOverline" },
          { " ", "BorderOverline" },
          { " ", "BorderOverline" },
          { " ", "Normal" },
          { " ", "BorderUnderline" },
          { " ", "BorderUnderline" },
          { " ", "BorderUnderline" },
          { " ", "Normal" },
        },
        style = "minimal",
        focusable = true,
      })
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.api.nvim_set_option_value("signcolumn", "yes:1", { win = win, scope = "local" })
      vim.api.nvim_set_option_value(
        "winhl",
        "Normal:CursorLine,FloatTitle:FloatTitleOverline",
        { win = win, scope = "local" }
      )
      vim.api.nvim_set_option_value("wrap", true, { win = win, scope = "local" })
      vim.api.nvim_set_option_value("modifiable", false, { scope = "local", buf = buf })

      local height = vim.api.nvim_win_text_height(win, {
        start_row = 0,
        end_row = vim.api.nvim_buf_line_count(buf) - 1,
      }).all

      vim.api.nvim_win_resize(win, -1, height)

      local vim_resized_id = vim.api.nvim_create_autocmd("VimResized", {
        callback = function()
          local h = vim.api.nvim_win_text_height(win, {
            start_row = 0,
            end_row = vim.api.nvim_buf_line_count(buf) - 1,
          }).all

          vim.api.nvim_win_resize(win, -1, h)
        end,
      })

      local ns_id = vim.api.nvim_create_namespace("eye-buffer")
      vim.api.nvim_buf_set_extmark(buf, ns_id, curr_buf_row - 1, 0, {
        line_hl_group = "Directory",
      })

      local close_win = function()
        vim.api.nvim_del_autocmd(vim_resized_id)
        vim.api.nvim_win_close(win, true)
      end

      local special = vim.api.nvim_get_hl(0, { name = "Special" })
      vim.api.nvim_set_hl(0, "EyeSignLabel", {
        fg = special.fg,
        bold = true,
      })

      local eye = require("_eye.core"):new(labels)
      eye:active({
        flush = function()
          vim.cmd.redraw()
        end,
        complete = function(ctx)
          local data = ctx.data or {}
          if data.bufnr ~= curr_buf then
            vim.api.nvim_win_set_buf(curr_win, data.bufnr)
            close_win()
          end
        end,
        cancel = function()
          close_win()
        end,
        update = function(ctx)
          local text = vim.fn.join(ctx.labels, "")
          local id1 = vim.api.nvim_buf_set_extmark(ctx.data.buf, ns_id, ctx.data.row - 1, ctx.data.col, {
            virt_text = { { text, "EyeSignLabel" } },
          })
          local id2 = vim.api.nvim_buf_set_extmark(ctx.data.buf, ns_id, ctx.data.row - 1, 0, {
            sign_text = text,
            sign_hl_group = "EyeSignLabel",
          })
          return function()
            vim.api.nvim_buf_del_extmark(ctx.data.buf, ns_id, id1)
            vim.api.nvim_buf_del_extmark(ctx.data.buf, ns_id, id2)
          end
        end,
      })
    end

    local function eye_bdelete()
      local curr_buf = vim.api.nvim_get_current_buf()
      local buf = vim.api.nvim_create_buf(false, true)
      local bufs = {}
      local lines = {}
      local labels = {}
      local curr_buf_row
      local list_bufs = vim.api.nvim_list_bufs()
      local max_bufnr_strlen = #tostring(list_bufs[#list_bufs])
      for _, b in ipairs(list_bufs) do
        if vim.api.nvim_get_option_value("buflisted", {
          buf = b,
        }) then
          local bufname = vim.api.nvim_buf_get_name(b)
          bufname = vim.fn.fnamemodify(bufname, ":p:.")
          if bufname == "" then
            bufname = "[[No Name]]"
          end
          local bufnr_str = tostring(b)
          bufnr_str = bufnr_str .. string.rep(" ", max_bufnr_strlen - #bufnr_str)
          local line = "#" .. bufnr_str .. " " .. bufname
          table.insert(lines, line)
          table.insert(bufs, b)
          table.insert(labels, {
            buf = buf,
            row = #bufs,
            col = 0,
            bufnr = b,
          })
          if b == curr_buf then
            curr_buf_row = #bufs
          end
        end
      end

      vim.api.nvim_set_hl(0, "BorderUnderline", { underline = true })
      vim.api.nvim_set_hl(0, "BorderOverline", { overline = true })
      local FloatTitle = vim.api.nvim_get_hl(0, {
        name = "FloatTitle",
        link = false,
      })
      vim.api.nvim_set_hl(0, "FloatTitleOverline", { overline = true, fg = FloatTitle.fg, bold = true })
      local win = vim.api.nvim_open_win(buf, false, {
        relative = "laststatus",
        height = #bufs,
        width = 10000,
        col = 2,
        row = -#bufs - (vim.o.laststatus == 3 and 1 or 0) - 1,
        title = "▶bdelete◀",
        title_pos = "center",
        noautocmd = true,
        border = {
          { " ", "BorderOverline" },
          { " ", "BorderOverline" },
          { " ", "BorderOverline" },
          { " ", "Normal" },
          { " ", "BorderUnderline" },
          { " ", "BorderUnderline" },
          { " ", "BorderUnderline" },
          { " ", "Normal" },
        },
        style = "minimal",
        focusable = true,
      })

      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.api.nvim_set_option_value("signcolumn", "yes:1", { win = win, scope = "local" })
      vim.api.nvim_set_option_value(
        "winhl",
        "Normal:CursorLine,FloatTitle:FloatTitleOverline",
        { win = win, scope = "local" }
      )
      vim.api.nvim_set_option_value("wrap", true, { win = win, scope = "local" })
      vim.api.nvim_set_option_value("modifiable", false, { scope = "local", buf = buf })

      local height = vim.api.nvim_win_text_height(win, {
        start_row = 0,
        end_row = vim.api.nvim_buf_line_count(buf) - 1,
      }).all

      vim.api.nvim_win_resize(win, -1, height)

      local vim_resized_id = vim.api.nvim_create_autocmd("VimResized", {
        callback = function()
          local h = vim.api.nvim_win_text_height(win, {
            start_row = 0,
            end_row = vim.api.nvim_buf_line_count(buf) - 1,
          }).all

          vim.api.nvim_win_resize(win, -1, h)
        end,
      })

      local ns_id = vim.api.nvim_create_namespace("eye-bdelete")
      vim.api.nvim_buf_set_extmark(buf, ns_id, curr_buf_row - 1, 0, {
        line_hl_group = "Directory",
      })

      local close_win = function()
        vim.api.nvim_del_autocmd(vim_resized_id)
        vim.api.nvim_win_close(win, true)
      end

      local special = vim.api.nvim_get_hl(0, { name = "Special" })
      vim.api.nvim_set_hl(0, "EyeSignLabel", {
        fg = special.fg,
        bold = true,
      })

      local eye = require("_eye.core"):new(labels)
      eye:active({
        flush = function()
          vim.cmd.redraw()
        end,
        cancel = function()
          close_win()
        end,
        complete = function(ctx)
          local data = ctx.data or {}
          pcall(vim.api.nvim_buf_delete, data.bufnr, { force = false })
          close_win()
        end,
        update = function(ctx)
          local text = vim.fn.join(ctx.labels, "")
          local id1 = vim.api.nvim_buf_set_extmark(ctx.data.buf, ns_id, ctx.data.row - 1, ctx.data.col, {
            virt_text = { { text, "EyeSignLabel" } },
          })
          local id2 = vim.api.nvim_buf_set_extmark(ctx.data.buf, ns_id, ctx.data.row - 1, 0, {
            sign_text = text,
            sign_hl_group = "EyeSignLabel",
          })
          return function()
            vim.api.nvim_buf_del_extmark(ctx.data.buf, ns_id, id1)
            vim.api.nvim_buf_del_extmark(ctx.data.buf, ns_id, id2)
          end
        end,
      })
    end

    local cmdproxy = require("command-proxy")
    cmdproxy.setup({
      proxy = {
        ["bdelete"] = function(cmd_info)
          if cmd_info.count == 0 then
            vim.schedule(function()
              eye_bdelete()
            end)
            return true
          end
        end,
        ["buffer"] = function(cmd_info)
          if not cmd_info.range and #cmd_info.args == 0 then
            vim.schedule(function()
              eye_buffer()
            end)
            return true
          end
        end,
        ["bprevious"] = function(cmd_info)
          if cmd_info.count == 0 then
            vim.schedule(function()
              eye_buffer()
            end)
            return true
          end
        end,
        ["bnext"] = function(cmd_info)
          if cmd_info.count == 0 then
            vim.schedule(function()
              eye_buffer()
            end)
            return true
          end
        end,
        ["write"] = function(cmd_info)
          local buf = vim.api.nvim_get_current_buf()
          if vim.bo[buf].buftype == "acwrite" then
            return
          end
          if cmd_info.args and #cmd_info.args == 0 then
            return "update"
          end
        end,
        -- :0close<cr>
        ["close"] = function(cmd_info)
          if cmd_info.count == 0 then
            return true
          end
        end,
        ["delete"] = function(cmd_info)
          if cmd_info.count == 0 then
            return true
          end
        end,
        ["cnext"] = function(cmd_info)
          if cmd_info.count == 0 then
            return true
          end
        end,
        ["cprevious"] = function(cmd_info)
          if cmd_info.count == 0 then
            return true
          end
        end,
        ["ls"] = function()
          cmd_to_reg("ls")
        end,
        ["buffers"] = function()
          cmd_to_reg("buffers")
        end,
        ["pwd"] = function()
          cmd_to_reg("pwd")
        end,
        [my.command.constants.FILETYPE_LS] = function()
          cmd_to_reg("Fls")
        end,
      },
    })
    vim.api.nvim_create_autocmd("CmdwinEnter", {
      callback = function()
        cmdproxy.proxy("bnext", function()
          local cmdwin = require("builtin.cmdwin")
          vim.schedule(function()
            cmdwin.switch_cmdwin(1)
          end)
          return true
        end, { buf = 0 })

        cmdproxy.proxy("bprevious", function()
          local cmdwin = require("builtin.cmdwin")
          vim.schedule(function()
            cmdwin.switch_cmdwin(-1)
          end)
          return true
        end, { buf = 0 })
      end,
    })
  end,
}
