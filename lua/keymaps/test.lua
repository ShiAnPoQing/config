return {
  ["<leader>1"] = {
    function()
      local ns = vim.api.nvim_create_namespace("cmdline_ui")

      local win
      local buf

      local function open_cmdline()
        buf = vim.api.nvim_create_buf(false, true)

        win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          row = 10,
          col = 20,
          width = 40,
          height = 1,
          style = "minimal",
          border = "rounded",
          -- focusable = true,
          noautocmd = true,
        })
        -- vim.api.nvim_buf_call(buf, function()
        --   vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "test" })
        -- end)
      end

      local function close_cmdline()
        if win and vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
          win = nil
        end
      end
      local timer = vim.loop.new_timer()
      vim.ui_attach(ns, { ext_cmdline = true }, function(event, ...)
        if win and event == "cmdline_hide" then
          close_cmdline()
        end

        if event == "cmdline_show" then
          if not win then
            timer:start(
              0,
              0,
              vim.schedule_wrap(function()
                timer:stop()
                open_cmdline()
                -- vim.cmd.redraw()
                -- vim.schedule(function()
                vim.api.nvim_win_set_cursor(win, { 1, 0 })
                vim.cmd.startinsert()
                vim.api.nvim__redraw({ cursor = true, win = win, flush = true })
                -- vim.cmd.redraw()
                -- end)
              end)
            )
            return true
          end
          -- vim.print(event)
          -- local content = select(1, ...)
          -- local text = ""
          --
          -- for _, chunk in ipairs(content[1]) do
          --   text = text .. chunk[1]
          -- end
          --
        elseif event == "cmdline_pos" then
          timer:start(
            0,
            0,
            vim.schedule_wrap(function()
              timer:stop()
              vim.print("test")
              vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "test" })
              -- vim.cmd.redraw()
              -- vim.schedule(function()
              -- vim.cmd.startinsert()
              vim.api.nvim__redraw({ buf = buf, win = win, flush = true })
              -- vim.cmd.redraw()
              -- end)
            end)
          )
          --   vim.schedule(function()
          --     vim.api.nvim_win_set_cursor(win, { 1, 0 })
          --   end)
          -- elseif event == "cmdline_hide" then
          --   close_cmdline()
        end
        return true
      end)
    end,
    "n",
  },
  ["<leader>2"] = {
    function() end,
    "n",
  },
  ["<leader>3"] = {
    function()
      local function input(opts, cb)
        local buf = vim.api.nvim_create_buf(false, true)

        vim.bo[buf].buftype = "prompt"

        local win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = 40,
          height = 1,
          row = 10,
          col = 10,
          border = "single",
        })

        vim.fn.prompt_setprompt(buf, opts.prompt or "")

        vim.fn.prompt_setcallback(buf, function(text)
          vim.api.nvim_win_close(win, true)
          cb(text)
        end)

        vim.fn.prompt_setinterrupt(buf, function()
          vim.api.nvim_win_close(win, true)
          cb(nil)
        end)

        vim.cmd("startinsert")
      end
      input({ prompt = "Input: " }, function(text)
        vim.print("You entered: " .. (text or ""))
      end)
    end,
    "n",
  },
  ["<leader>`"] = {
    function()
      local params = {
        textDocument = vim.lsp.util.make_text_document_params(),
      }

      vim.lsp.buf_request(0, "textDocument/documentSymbol", params, function(err, result, ctx, _)
        if err then
          print("LSP error:", err)
          return
        end

        if not result then
          print("No symbols")
          return
        end

        print(vim.inspect(result))
      end)
    end,
    "n",
  },
  ["<leader>4"] = {
    function()
      local function centercursor()
        -- I don't know if this is the most optimal way to autocenter
        -- But it seems to work
        vim.api.nvim_exec2("normal! zz", {})
      end

      -- NOTE: There is a sligtly noticeable "bump"
      -- when approaching EOF, for now I don't know how to fix
      local function centerscroll()
        local visible_lines = vim.fn.winheight(0)
        local screen_center = math.ceil(visible_lines / 2)

        local distance_to_eof = vim.fn.line("$") - vim.fn.line(".")

        -- Through testing it seems that keeping scrolloff constantly on doesn't do any harm
        vim.opt.scrolloff = screen_center

        if distance_to_eof <= screen_center then
          centercursor()
        end
      end

      local M = {}

      -- Instantiate a variable outside the scope of autocmd,
      -- to record the line where the cursor was on previous check
      local checkline = nil
      function M.setup()
        vim.api.nvim_create_autocmd("CursorMoved", {
          callback = function()
            -- Since calling centerscroll function on every move of the cursor is expensive,
            -- this only performs the call when the line is changed
            if vim.fn.line(".") ~= checkline then
              -- Call the function, then record current line in a variable for the latter checks.
              -- Very simple.
              centerscroll()
              checkline = vim.fn.line(".")
            end
          end,
        })
      end
      M.setup()
    end,
    "n",
  },
  ["<leader>5"] = {
    function()
      -- 1️⃣ 创建 namespace（你的插件必须有自己的）
      local ns = vim.api.nvim_create_namespace("my_diag")

      -- 2️⃣ 获取当前 buffer（也可以换成指定 bufnr）
      local bufnr = vim.api.nvim_get_current_buf()

      -- 3️⃣ 构造一个 diagnostic
      ---@type vim.Diagnostic.Set[]
      local diags = {
        {
          lnum = 2, -- 行号（0-based！第3行）
          col = 4, -- 列号（0-based）
          end_lnum = 2, -- 可选
          end_col = 10, -- 可选
          severity = vim.diagnostic.severity.ERROR,
          source = "my-plugin",
          message = "Something went wrong",
        },
      }
      -- 4️⃣ 设置 diagnostic
      vim.diagnostic.set(ns, bufnr, diags)
    end,
    "n",
  },
  ["<leader>6"] = {
    function()
      ------@param r number 0-255
      ------@param g number 0-255
      ------@param b number 0-255
      ------@return string
      ---local function rgb_to_hex(r, g, b)
      ---  return string.format("#%02x%02x%02x", r, g, b)
      ---end
      ----- rgb_to_hex(128, 128, 128)
    end,
    "n",
  },
}

--[[
/**
 * 表示出现在文档中的编程结构，例如变量、类、接口等。
 * DocumentSymbol 可以是分层结构（具有父子关系），
 * 并包含两个范围：
 *  - 一个用于包裹其完整定义的范围
 *  - 一个指向其最重要部分（例如标识符名称）的范围
 */
export interface DocumentSymbol {

  /**
   * 符号名称。
   * 将在用户界面中显示，因此不能为空字符串或仅包含空白字符的字符串。
   */
  name: string;

  /**
   * 符号的附加详细信息，例如函数签名。
   */
  detail?: string;

  /**
   * 该符号的类型。
   */
  kind: SymbolKind;

  /**
   * 符号标签。
   *
   * @since 3.16.0
   */
  tags?: SymbolTag[];

  /**
   * 表示该符号是否已被弃用。
   *
   * @deprecated 请改用 tags 字段
   */
  deprecated?: boolean;

  /**
   * 包含该符号完整定义的范围。
   * 不包括前导或尾随空白字符，
   * 但包括其他内容（例如注释）。
   *
   * 此信息通常用于判断客户端光标是否位于该符号内部，
   * 以便在 UI 中将其展开或高亮显示。
   */
  range: Range;

  /**
   * 当用户选中该符号时，
   * 应当被选中并展示的范围（例如函数名称本身）。
   *
   * 该范围必须包含在 `range` 内。
   */
  selectionRange: Range;

  /**
   * 子符号，例如类中的属性或方法。
   */
  children?: DocumentSymbol[];
}

/**
 * A symbol kind.
 */
export namespace SymbolKind {
	export const File = 1;
	export const Module = 2;
	export const Namespace = 3;
	export const Package = 4;
	export const Class = 5;
	export const Method = 6;
	export const Property = 7;
	export const Field = 8;
	export const Constructor = 9;
	export const Enum = 10;
	export const Interface = 11;
	export const Function = 12;
	export const Variable = 13;
	export const Constant = 14;
	export const String = 15;
	export const Number = 16;
	export const Boolean = 17;
	export const Array = 18;
	export const Object = 19;
	export const Key = 20;
	export const Null = 21;
	export const EnumMember = 22;
	export const Struct = 23;
	export const Event = 24;
	export const Operator = 25;
	export const TypeParameter = 26;
}

export type SymbolKind = 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 | 25 | 26;
--]]
