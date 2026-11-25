return {
  "luukvbaal/statuscol.nvim",
  lazy = false,
  config = function()
    local fold_func = function(args)
      local C = require("statuscol.ffidef").C
      local width = args.fold.width
      if width == 0 then
        return ""
      end

      local foldinfo = C.fold_info(args.wp, args.lnum)
      local str = args.cul and args.relnum == 0 and "%#CursorLineFold#" or "%#FoldColumn#"
      local level = foldinfo.level

      if level == 0 then
        return str .. (" "):rep(width) .. "%*"
      end

      local closed = foldinfo.lines > 0
      local first_level = level - width - (closed and 1 or 0) + 1
      if first_level < 1 then
        first_level = 1
      end

      local prev_line_level = vim.fn.foldlevel(args.lnum - 1)
      local next_line_level = vim.fn.foldlevel(args.lnum + 1)

      local is_fold_start = foldinfo.start == args.lnum
      local is_fold_end = not next_line_level or next_line_level < level

      local fold_start_icon = ""
      if is_fold_start then
        if level > prev_line_level then
          fold_start_icon = level == 1 and "┌" or "┬"
        elseif level <= prev_line_level then
          fold_start_icon = "┝"
        end
      end

      local fold_end_icon = ""
      if is_fold_end then
        fold_end_icon = level == 1 and "└" or "┴"
      end

      local range = level < width and level or width
      for col = 1, range do
        if args.virtnum ~= 0 then
          str = str .. args.fold.sep
          goto next
        end

        if closed and (col == level or col == width) then
          str = str .. args.fold.close
          goto next
        end

        if first_level + col > foldinfo.llevel then
          if col == level then
            if is_fold_start then
              str = str .. fold_start_icon
            elseif is_fold_end then
              str = str .. fold_end_icon
            else
              str = str .. args.fold.sep
            end
          else
            if is_fold_start then
              str = str .. "├"
            elseif is_fold_end then
              str = str .. args.fold.sep
              -- str = str .. "└"
            else
              str = str .. args.fold.sep
            end
          end
        else
          if is_fold_start then
            if first_level + col - 1 == prev_line_level then
              if fold_start_icon ~= "├" then
                str = str .. "├"
              else
                str = str .. args.fold.sep
              end
            else
              str = str .. args.fold.sep
            end
          elseif is_fold_end then
            if first_level + col - 1 == next_line_level then
              str = str .. "├"
            elseif first_level + col - 1 > next_line_level then
              str = str .. fold_end_icon
            else
              str = str .. args.fold.sep
            end
          else
            str = str .. args.fold.sep
          end
        end

        ::next::
      end

      if range < width then
        str = str .. (" "):rep(width - range)
      end

      return str .. "%*"
    end

    require("statuscol").setup({
      setopt = true,
      ft_ignore = { "neo-tree", "neo-tagstack" },
      bt_ignore = { "neo-tree" },
      segments = {
        {
          sign = {
            namespace = { ".*" },
            name = { ".*" },
            colwidth = 1,
            maxwidth = 1,
          },
        },
        {
          text = {
            function(args)
              return "%=" .. (args.relnum == 0 and args.lnum or args.relnum)
            end,
            " ",
          },
          click = "v:lua.ScLa",
        },
        {
          text = {
            fold_func,
            " ",
          },
          click = "v:lua.ScFa",
          -- condition = {
          --   true,
          --   function(args)
          --     return args.fold.width ~= 0
          --   end,
          -- },
        },
      },
    })
  end,
}
