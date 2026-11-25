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

      local open_icon
      local prev_line_fold_level = 0
      if args.lnum - 1 > 0 then
        prev_line_fold_level = vim.fn.foldlevel(args.lnum - 1)
      end
      if level > prev_line_fold_level then
        if foldinfo.start == args.lnum then
          if level == 1 then
            open_icon = "┌"
          else
            open_icon = "┬"
          end
        end
      elseif level == prev_line_fold_level then
        if foldinfo.start == args.lnum then
          open_icon = "├"
        end
      elseif level < prev_line_fold_level then
        if foldinfo.start == args.lnum then
          open_icon = "├"
        end
      end

      --[[
        ┌   A 1 start
        │
        ├┬  B 2 start
        ││
        │├┬ C 3 start
        │││
        ││├ D 3 start
        ││├ D 3 end
        │││
        │├┴ C 3 end
        ││
        ├┴  B 2 end
        └   A 1 end
      --]]

      -- For each column, add a foldopen, foldclosed, foldsep or padding char
      local range = level < width and level or width
      for col = 1, range do
        if args.virtnum ~= 0 then
          str = str .. args.fold.sep
        elseif closed and (col == level or col == width) then
          str = str .. args.fold.close
        elseif foldinfo.start == args.lnum and first_level + col > foldinfo.llevel then
          str = str .. (open_icon or "A")
        else
          if open_icon then
            if first_level + col < foldinfo.llevel then
              str = str .. args.fold.sep
            else
              if open_icon ~= "├" then
                str = str .. "├"
              else
                str = str .. args.fold.sep
              end
            end
          else
            local next_level = vim.fn.foldlevel(args.lnum + 1)
            if next_level and next_level < level then
              if level == 1 then
                str = str .. "└"
              else
                if col == level then
                  str = str .. "┴"
                elseif col == level - 1 then
                  str = str .. "├"
                else
                  str = str .. args.fold.sep
                end
              end
            else
              str = str .. args.fold.sep
            end
          end
        end
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
          condition = {
            true,
            function(args)
              return args.fold.width ~= 0
            end,
          },
        },
      },
    })

    _G.my_status_column = function()
      return require("statuscol").get_statuscol_string()
    end

    vim.o.statuscolumn = "%{%v:lua.my_status_column()%}"
  end,
}
