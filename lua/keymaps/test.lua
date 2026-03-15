return {
  ["<leader>1"] = {
    function()
      local ns = vim.api.nvim_create_namespace("cmdline_ui")

      local win
      local buf

      local function open_cmdline()
        buf = vim.api.nvim_create_buf(false, true)

        win = vim.api.nvim_open_win(buf, false, {
          relative = "editor",
          row = 10,
          col = 20,
          width = 40,
          height = 1,
          style = "minimal",
          border = "rounded",
          focusable = true,
        })
      end

      local function close_cmdline()
        if win and vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
          win = nil
        end
      end
      vim.ui_attach(ns, { ext_cmdline = true }, function(event, ...)
        if win and event == "cmdline_hide" then
          close_cmdline()
        end

        if event == "cmdline_show" then
          if not win then
            vim.schedule(function()
              open_cmdline()
              vim.api.nvim_win_set_cursor(win, { 1, 0 })
              vim.cmd.redraw()
              vim.cmd.redraw()
            end)
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
          --   vim.schedule(function()
          --     vim.api.nvim_win_set_cursor(win, { 1, 0 })
          --   end)
          -- elseif event == "cmdline_hide" then
          --   close_cmdline()
        end
      end)
    end,
    "n",
  },
  ["<leader>2"] = {
    function()
      local key = vim.api.nvim_replace_termcodes(":s/a/b<cr>", true, false, true)
      vim.api.nvim_feedkeys(key, "m", true)
    end,
    "n",
  },
  ["<leader>3"] = {
    function() end,
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
