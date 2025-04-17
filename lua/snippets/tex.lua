local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet


local tex = {}
tex.in_mathzone = function()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
tex.in_text = function()
  return not tex.in_mathzone()
end

local function hasCapture(cap)
  return type(cap) == "table" and next(table) ~= nil
end

local function has_TM_SELECTED_TEXT(snip)
  local TM_SELECTED_TEXT = snip.env.TM_SELECTED_TEXT
  return type(TM_SELECTED_TEXT) == "table" and next(TM_SELECTED_TEXT) ~= nil
end

local function dynamic_node_select_text(args, snip)
  if has_TM_SELECTED_TEXT(snip) then
    return sn(nil, {
      i(1, snip.env.TM_SELECTED_TEXT)
    })
  else
    return sn(nil, { i(1) })
  end
end

local rec_enum
rec_enum = function()
  return sn(nil, {
    c(1, {
      t({ "" }),
      sn(nil, {
        t({ "", "\t\\item " }),
        i(1),
        d(2, rec_enum, {}),
      }),
      sn(1, {
        t({ "", "\t\\item[" }),
        i(2),
        t("] "),
        i(1),
        d(3, rec_enum, {}),
      }),
    }),
  })
end

local function create_tex_command(cmd)
  return {
    t("\\" .. cmd .. "{"),
    d(1, dynamic_node_select_text),
    t("}")
  }
end

local snippets = {
  s({
    trig = "\\([sub]*)section{([^}]*)}([%-%+])(%d)",
    regTrig = true,
  }, {
    f(function(args, snip)
      local str_sub = snip.captures[1]
      local m2 = snip.captures[2]
      local action = snip.captures[3]
      local action_count = snip.captures[4]

      local str_sub_count;
      local i = 0;
      for _ in string.gmatch(str_sub, "sub") do
        i = i + 1
      end

      if action == "-" then
        str_sub_count = math.max(i - action_count, 0)
      else
        str_sub_count = math.min(i + action_count, 2)
      end
      local sub = string.rep("sub", str_sub_count)
      return "\\" .. sub .. "section{" .. m2 .. "}"
    end)
  }),

  s("beg", {
    t("\\begin{"),
    i(1),
    t({ "}", "" }),
    d(2, function(_, snip)
      if next(snip.env.TM_SELECTED_TEXT) == nil then
        return sn(nil, { t("\t"), i(1) })
      else
        return sn(1, {
          t("\t"),
          isn(1, i(1, snip.env.TM_SELECTED_TEXT), "\t"),
        })
      end
    end, {}),
    t({ "", "\\end{" }),
    extras.rep(1),
    t("}"),
    i(3),
  }),


  s("inpt", {
    d(1, function(_, snip)
      if next(snip.env.TM_SELECTED_TEXT) == nil then
        return sn(1, {
          t("\\input{"),
          i(1),
          t("}"),
        })
      else
        local path = string.gsub(snip.env.TM_SELECTED_TEXT[1], "\\", "/")
        return sn(1, {
          t("\\input{"),
          i(1, path),
          t("}"),
        })
      end
    end),
  }),

  s("incld", {
    d(1, function(_, snip)
      local reg = vim.fn.getreg('"')
      local is_path = reg:match("\\")

      local new_path = {}
      if is_path then
        new_path[1] = string.gsub(reg, "\\", "/")
      else
        new_path[1] = "Path"
      end

      return sn(1, {
        t("\\include{"),
        i(1, new_path),
        t("}"),
      })
    end),
  }),


  s("alg", {
    t("\\begin{"),
    c(1, {
      i(1, "aligned"),
      i(1, "align"),
      i(1, "gathered"),
      i(1, "gather"),
    }),
    t({ "}", "" }),
    d(2, function(_, snip)
      if next(snip.env.TM_SELECTED_TEXT) == nil then
        return sn(nil, { t("\t"), i(1, "Text") })
      else
        return sn(1, {
          t("\t"),
          isn(1, i(1, snip.env.TM_SELECTED_TEXT), "\t"),
        })
      end
    end, {}),
    t({ "", "\\end{" }),
    extras.rep(1),
    t("}"),
    i(3),
  }, {
    condition = tex.in_mathzone,
    show_condition = tex.in_mathzone,
  }),

  postfix({
    trig = ".t",
    match_pattern = "%S+$",
  }, {
    f(function(_, parent)
      return "\\text{" .. parent.snippet.env.POSTFIX_MATCH .. "}"
    end, {}),
  }),

  postfix({
    trig = "%.(%l%l)(%l?%l?)",
    regTrig = true,
    match_pattern = "%S+$",
  }, {
    f(function(_, parent)
      local font1 = parent.captures[1]
      local font2 = parent.captures[2]

      if font2 == "" then
        return "\\text" .. font1 .. "{" .. parent.snippet.env.POSTFIX_MATCH .. "}"
      else
        return "\\text" .. font1 .. "{" .. "\\text" .. font2 .. "{" .. parent.snippet.env.POSTFIX_MATCH .. "}}"
      end
    end, {}),
  }, {
    condition = function(line, trig, capture)
      if vim.fn["vimtex#syntax#in_mathzone"]() ~= 1 then
        local match = { "rm", "bf", "it", "tt" }
        for key, value in pairs(match) do
          if capture[1] == value then
            if capture[2] == "" then
              return true
            else
              for key, value in pairs(match) do
                if capture[2] == value then
                  return true
                end
              end
            end
          end
        end
      end
    end,
  }),

  postfix({
    trig = "%.(%l%l)(%l?%l?)",
    regTrig = true,
    match_pattern = "%S+$",
  }, {
    f(function(_, parent)
      local font1 = parent.captures[1]
      local font2 = parent.captures[2]

      if font2 == "" then
        return "\\math" .. font1 .. "{" .. parent.snippet.env.POSTFIX_MATCH .. "}"
      else
        return "\\math" .. font1 .. "{" .. "\\math" .. font2 .. "{" .. parent.snippet.env.POSTFIX_MATCH .. "}}"
      end
    end, {}),
  }, {
    condition = function(line, trig, capture)
      if vim.fn["vimtex#syntax#in_mathzone"]() == 1 then
        local match = { "rm", "bf", "it", "tt" }
        for key, value in pairs(match) do
          if capture[1] == value then
            if capture[2] == "" then
              return true
            else
              for key, value in pairs(match) do
                if capture[2] == value then
                  return true
                end
              end
            end
          end
        end
      end
    end,
  }),

  -- s({
  --   trig = "|(|?)",
  --   regTrig = true,
  --   hidden = true,
  --   wordTrig = false,
  -- }, {
  --   d(1, function(_, snip)
  --     if snip.captures[1] ~= "" then
  --       if next(snip.env.TM_SELECTED_TEXT) == nil then
  --         return sn(1, {
  --           t("\\mid "),
  --           i(1, "SOMETHING"),
  --           t(" \\mid"),
  --         })
  --       else
  --         return sn(1, {
  --           t("\\mid "),
  --           i(1, snip.env.TM_SELECTED_TEXT),
  --           t(" \\mid"),
  --         })
  --       end
  --     else
  --       return sn(1, {
  --         t("\\mid"),
  --       })
  --     end
  --   end),
  -- }),
  s(
    "nn",
    c(1, {
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t({ "\\[", "\t" }), r(1, "math"), t({ "", "\\]" }) })
        else
          return sn(1, {
            t({ "\\[ ", "\t" }),
            isn(1, t(""), "\t"),
            r(2, "math", i(1, snip.env.TM_SELECTED_TEXT)),
            t({ "", "\\]" }),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("$ "), r(1, "math", i(1, "Math")), t(" $") })
        elseif #snip.env.TM_SELECTED_TEXT == 1 then
          return sn(1, {
            t("$ "),
            r(1, "math", i(1, snip.env.TM_SELECTED_TEXT)),
            t(" $"),
          })
        elseif #snip.env.TM_SELECTED_TEXT > 1 then
          return sn(1, {
            t({ "\\[", "\t" }),
            isn(1, r(1, "math", i(1, snip.env.TM_SELECTED_TEXT)), "$PARENT_INDENT"),
            t({ "", "\\]" }),
          })
        end
      end),
    }, {
      stored = {
        ["math"] = i(1),
      },
    }),
    {
      condition = tex.in_text,
      show_condition = tex.in_text,
    }
  ),

  s(
    "mm",
    c(1, {
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t(" $ "), r(1, "math", i(1, "Math")), t(" $ ") })
        elseif #snip.env.TM_SELECTED_TEXT == 1 then
          return sn(1, {
            t(" $ "),
            r(1, "math", i(1, snip.env.TM_SELECTED_TEXT)),
            t(" $ "),
          })
        elseif #snip.env.TM_SELECTED_TEXT > 1 then
          return sn(1, {
            t({ "\\[", "\t" }),
            isn(1, r(1, "math", i(1, snip.env.TM_SELECTED_TEXT)), "$PARENT_INDENT"),
            t({ "", "\\]" }),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t({ "\\[", "\t" }), r(1, "math"), t({ "", "\\]" }) })
        elseif #snip.env.TM_SELECTED_TEXT > 1 then
          return sn(1, {
            t({ " $", "" }),
            isn(1, r(1, "math", i(1, snip.env.TM_SELECTED_TEXT)), "$PARENT_INDENT"),
            t({ "", "$ " }),
          })
        elseif #snip.env.TM_SELECTED_TEXT == 1 then
          return sn(1, {
            t({ "\\[ ", "\t" }),
            isn(1, t(""), "\t"),
            r(2, "math"),
            t({ "", "\\]" }),
          })
        end
      end),
    }, {
      stored = {
        ["math"] = i(1),
      },
    }),
    {
      condition = tex.in_text,
      show_condition = tex.in_text,
    }
  ),

  s({
    trig = "fra(.*)",
    regTrig = true,
    hidden = true,
    wordTrig = false,
  }, {
    d(1, function(_, snip)
      -- 储存前面的捕获，用于还原
      local store
      local text
      -- 要删除的触发器长度
      local cut_count

      -- 判断是否有可视选中文本
      if next(snip.env.TM_SELECTED_TEXT) == nil then
        text = "分子"
      else
        text = snip.env.TM_SELECTED_TEXT
      end

      if snip.captures[1] == "" then
        node = sn(1, {
          t("\\frac{"),
          i(1, text),
          t("}{"),
          i(2, "分母"),
          t("}"),
        })
      elseif snip.captures[1] ~= "" then
        local math1 = string.match(snip.captures[1], "fra%s*$")

        if math1 ~= nil then
          cut_count = #math1 + 1
        else
          cut_count = #string.match(snip.captures[1], "%s+$")
        end

        store = string.sub(snip.captures[1], 1, -cut_count)
        node = sn(1, {
          t("fra"),
          t(store),
          t("\\frac{"),
          i(1, "分子"),
          t("}{"),
          i(2, "分母"),
          t("}"),
        })
      end
      return node
    end),
  }, {
    condition = function(line, trig, capture)
      -- 只在数学模式触发
      if vim.fn["vimtex#syntax#in_mathzone"]() == 1 then
        if capture[1] ~= "" then
          local math1 = string.match(line, "\\frac{")
          local math2 = string.match(line, "%s%s+$")
          local math3 = string.match(line, "fra%s*$")
          if (math1 ~= nil and math2 ~= nil) or (math1 ~= nil and math3 ~= nil) then
            return true
          end
        else
          return true
        end
      end
    end,
    show_condition = tex.in_mathzone,
  }),


  s({
    trig = "lr([{%[%(|<]?)([}%)>%]|]?)",
    regTrig = true,
    hidden = true,
    wordTrig = false,
  }, {
    c(1, {
      d(1, function(args, snip)
        local key1 = snip.captures[1]
        local key2 = snip.captures[2]

        local pairs_table = {
          ["("] = "(",
          [")"] = ")",
          ["["] = "[",
          ["]"] = "]",
          ["{"] = "\\{",
          ["}"] = "\\}",
          ["<"] = "\\langle",
          [">"] = "\\rangle",
          ["|"] = "|",
          ["||"] = "\\|",
        }

        local pair = {}

        if key1 ~= "" then
          if key2 == "|" then
            table.insert(pair, pairs_table[key1 .. key2])
          else
            table.insert(pair, pairs_table[key1])
          end
        else
          table.insert(pair, ".")
        end

        if key2 ~= "" then
          if key2 == "|" then
            table.insert(pair, pairs_table[key1 .. key2])
          else
            table.insert(pair, pairs_table[key2])
          end
        else
          if key1 == "|" then
            table.insert(pair, pairs_table[key1])
          else
            table.insert(pair, ".")
          end
        end

        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, {
            t("\\left" .. pair[1]),
            r(1, "math", i(1, "math")),
            t("\\right" .. pair[2]),
          })
        elseif #snip.env.TM_SELECTED_TEXT == 1 then
          return sn(1, {
            t("\\left" .. pair[1]),
            r(1, "math", i(1, snip.env.TM_SELECTED_TEXT)),
            t("\\right" .. pair[2]),
          })
        elseif #snip.env.TM_SELECTED_TEXT > 1 then
          return sn(nil, {
            t({ "\\left" .. pair[1], "" }),
            t("\t"),
            r(1, "math", i(1, snip.env.TM_SELECTED_TEXT)),
            t({ "", "\\right" .. pair[2] }),
          })
        end
      end),
    }, {
      stored = {
        ["math"] = i(1),
      },
    }),
  }, {
    -- condition = function()
    --   -- local toggle = require("core.config.plugins.luasnip.utils").toggle
    --   -- if toggle == nil then
    --   -- return vim.fn["vimtex#syntax#in_mathzone"]() == 1
    --   -- else
    --   -- return true
    --   -- end
    -- end,
    -- show_condition = function()
    --   -- local toggle = require("core.config.plugins.luasnip.utils").toggle
    --   -- if toggle == nil then
    --   -- return vim.fn["vimtex#syntax#in_mathzone"]() == 1
    --   -- else
    --   -- return true
    --   -- end
    -- end,
  }),


  s({
    trig = "(%l%l)(%l?%l?)",
    regTrig = true,
    hidden = true,
    wordTrig = false,
  }, {
    t("\\math"),
    d(1, function(_, snip)
      if snip.captures[2] == "" then
        if snip.env.TM_SELECTED_TEXT == nil or snip.env.TM_SELECTED_TEXT == "" then
          return sn(1, {
            t(snip.captures[1]),
            t("{"),
            i(1, "Something"),
            t("}"),
          })
        else
          return sn(1, {
            t(snip.captures[1]),
            t("{"),
            i(1, snip.env.TM_SELECTED_TEXT),
            t("}"),
          })
        end
      else
        if snip.env.TM_SELECTED_TEXT == nil or snip.env.TM_SELECTED_TEXT == "" then
          return sn(1, {
            t(snip.captures[1]),
            t("{"),
            t("\\math"),
            t(snip.captures[2]),
            t("{"),
            i(1, "SOMETHING"),
            t("}"),
            t("}"),
          })
        else
          return sn(1, {
            t(snip.captures[1]),
            t("{"),
            t("\\math"),
            t(snip.captures[2]),
            t("{"),
            i(1, snip.env.TM_SELECTED_TEXT),
            t("}"),
            t("}"),
          })
        end
      end
    end),
  }, {
    condition = function(line, trig, capture)
      if vim.fn["vimtex#syntax#in_mathzone"]() == 1 then
        local match = { "rm", "bf", "it", "tt" }
        for key, value in pairs(match) do
          if capture[1] == value then
            if capture[2] == "" then
              return true
            else
              for key, value in pairs(match) do
                if capture[2] == value then
                  return true
                end
              end
            end
          end
        end
      end
    end,
  }),

  s("dlt", {
    t("\\Delta"),
  }, {
    condition = tex.in_mathzone,
    show_condition = tex.in_mathzone,
  }),

  s({
    trig = "·",
    hidden = true,
  }, {
    t(" \\cdot "),
  }, {
    condition = tex.in_mathzone,
  }),

  s({
    trig = "...",
    hidden = true,
  }, {
    t(" \\cdots "),
  }, {
    condition = tex.in_mathzone,
  }),

  s({
    trig = "sin",
    wordTrig = false,
  }, {
    t("\\sin"),
    i(1),
  }, {
    condition = function(line, trig, cap)
      local before_char = string.sub(line, - #trig - 1)
      if before_char ~= "\\sin" then
        return true
      end
    end,
  }, {
    condition = tex.in_mathzone,
  }),

  s({
    trig = "cos",
    wordTrig = false,
  }, {
    t("\\cos"),
    i(1),
  }, {
    condition = function(line, trig, cap)
      local before_char = string.sub(line, - #trig - 1)
      if before_char ~= "\\cos" then
        return true
      end
    end,
  }, {
    condition = tex.in_mathzone,
  }),

  s({
    trig = "tan",
    wordTrig = false,
  }, {
    t("\\tan"),
    i(1),
  }, {
    condition = function(line, trig, cap)
      local before_char = string.sub(line, - #trig - 1)
      if before_char ~= "\\tan" then
        return true
      end
    end,
  }, {
    condition = tex.in_mathzone,
  }),

  s("fbx", {
    c(2, {
      sn(1, { t("\\"), i(1, "fbox") }),
      sn(1, { t("\\"), i(1, "shadowbox") }),
    }),
    t("{"),
    d(1, function(_, snip)
      if next(snip.env.TM_SELECTED_TEXT) == nil then
        return sn(nil, {
          i(1, "Text"),
          t("}"),
        })
      elseif #snip.env.TM_SELECTED_TEXT == 1 then
        return sn(1, {
          i(1, snip.env.TM_SELECTED_TEXT),
          t("}"),
        })
      else
        for key, value in pairs(snip.env.TM_SELECTED_TEXT) do
          snip.env.TM_SELECTED_TEXT[key] = string.gsub(value, "^%s*", "")
        end
        return sn(1, {
          t({ "", "\t" }),
          isn(1, i(1, snip.env.TM_SELECTED_TEXT), "$PARENT_INDENT\t"),
          t({ "", "}" }),
        })
      end
    end),
    i(3),
  }),

  s("itbox", {
    t("\\item[\\fbox{"),
    d(1, function(_, snip)
      if next(snip.env.TM_SELECTED_TEXT) == nil then
        return sn(1, { i(1, "Label") })
      else
        return sn(1, i(1, snip.env.TM_SELECTED_TEXT))
      end
    end),
    t("}]"),
  }),

  s({
    trig = "itm(%d?)",
    regTrig = true,
    wordTrig = false,
  }, {
    c(1, {
      d(1, function(_, snip)
        local item_count
        if snip.captures[1] == "" then
          item_count = 1
        else
          item_count = tonumber(snip.captures[1])
        end

        local node_table = {}

        local i_number = 1
        local first_exe

        while item_count > 0 do
          if first_exe == true then
            table.insert(node_table, t({ "", "" }))
          end

          table.insert(node_table, isn(i_number, t("\\item"), "\t"))
          table.insert(node_table, t(" "))
          table.insert(node_table, i(i_number))
          i_number = i_number + 1

          first_exe = true

          item_count = item_count - 1
        end
        return sn(1, node_table)
      end),
      d(1, function(_, snip)
        local item_count
        if snip.captures[1] == "" then
          item_count = 1
        else
          item_count = tonumber(snip.captures[1])
        end

        local node_table = {}

        local i_number = 1
        local first_exe

        while item_count > 0 do
          if first_exe == true then
            table.insert(node_table, t({ "", "" }))
          end

          table.insert(node_table, isn(i_number, t("\\item["), "\t"))
          table.insert(node_table, i(i_number))
          table.insert(node_table, t("] "))
          i_number = i_number + 1
          table.insert(node_table, i(i_number))
          i_number = i_number + 1

          first_exe = true

          item_count = item_count - 1
        end
        return sn(1, node_table)
      end),
    }),
  }),

  s({
    trig = "ittt(%d?)",
    regTrig = true,
    wordTrig = false,
  }, {
    d(1, function(_, snip)
      local item_count
      if snip.captures[1] == "" then
        item_count = 1
      else
        item_count = tonumber(snip.captures[1])
      end

      local node_table = {}

      local i_number = 1
      local first_exe

      while item_count > 0 do
        if first_exe == true then
          table.insert(node_table, t({ "", "" }))
        end

        table.insert(node_table, isn(i_number, t("\\item[\\large\\tt"), "\t"))
        table.insert(node_table, i(i_number))
        table.insert(node_table, t("] "))
        i_number = i_number + 1
        table.insert(node_table, i(i_number))
        i_number = i_number + 1

        first_exe = true

        item_count = item_count - 1
      end
      return sn(1, node_table)
    end),
  }),

  s({
    trig = "itit(%d?)",
    regTrig = true,
    wordTrig = false,
  }, {
    d(1, function(_, snip)
      local item_count
      if snip.captures[1] == "" then
        item_count = 1
      else
        item_count = tonumber(snip.captures[1])
      end

      local node_table = {}

      local i_number = 1
      local first_exe

      while item_count > 0 do
        if first_exe == true then
          table.insert(node_table, t({ "", "" }))
        end

        table.insert(node_table, isn(i_number, t("\\item[\\large\\it"), "\t"))
        table.insert(node_table, i(i_number))
        table.insert(node_table, t("] "))
        i_number = i_number + 1
        table.insert(node_table, i(i_number))
        i_number = i_number + 1

        first_exe = true

        item_count = item_count - 1
      end
      return sn(1, node_table)
    end),
  }),

  s({
    trig = "itbf(%d?)",
    regTrig = true,
    wordTrig = false,
  }, {
    d(1, function(_, snip)
      local item_count
      if snip.captures[1] == "" then
        item_count = 1
      else
        item_count = tonumber(snip.captures[1])
      end

      local node_table = {}

      local i_number = 1
      local first_exe

      while item_count > 0 do
        if first_exe == true then
          table.insert(node_table, t({ "", "" }))
        end

        table.insert(node_table, isn(i_number, t("\\item[\\bf"), "\t"))
        table.insert(node_table, i(i_number))
        table.insert(node_table, t("] "))
        i_number = i_number + 1
        table.insert(node_table, i(i_number))
        i_number = i_number + 1

        first_exe = true

        item_count = item_count - 1
      end
      return sn(1, node_table)
    end),
  }),

  s({
    trig = "itd(%d?%d?)",
    regTrig = true,
    wordTrig = false,
  }, {
    t("\\item[\\large \\ding{"),
    f(function(_, snip)
      local number
      if snip.captures[1] == "" then
        number = 172
      else
        number = tonumber(snip.captures[1]) + 171
      end
      return number .. "}] "
    end, {}, {}),
    i(1),
  }),

  s({
    trig = "it(%d)d(%d)",
    regTrig = true,
    wordTrig = false,
  }, {
    d(1, function(_, snip)
      local item_count = tonumber(snip.captures[1])
      local node_table = {}
      local ding_number = 71 + snip.captures[2]

      local i_number = 1
      local first_exe

      while item_count > 0 do
        if first_exe == true then
          table.insert(node_table, t({ "", "" }))
        end
        table.insert(node_table, isn(i_number, t("\\item[\\large \\ding{1"), "\t"))
        table.insert(node_table, t(tostring(ding_number)))
        table.insert(node_table, t("}] "))
        table.insert(node_table, i(i_number))
        i_number = i_number + 1
        ding_number = ding_number + 1

        if first_exe == nil then
          first_exe = true
        end

        item_count = item_count - 1
      end
      return sn(1, node_table)
    end, {}),
  }),

  s("enum", {
    t("\\begin{"),
    c(1, {
      i(1, "enumerate"),
      i(1, "itemize"),
      i(1, "description"),
    }),
    t("}"),
    f(function(args, _)
      local first_char = string.sub(args[1][1], 0, 1)
      if first_char == "[" or first_char == "" then
        return ""
      else
        return "["
      end
    end, { 2 }),
    i(2),
    f(function(args, _)
      local end_char = string.sub(args[1][1], -1)
      if end_char == "]" or end_char == "" then
        return ""
      else
        return "]"
      end
    end, { 2 }),
    t({ "", "\t\\item " }),
    i(3),
    d(4, rec_enum, {}),
    t({ "", "" }),
    i(5),
    t("\\end{"),
    rep(1),
    t("}"),
  }),

  s("itz", {
    t("\\begin{"),
    c(1, {
      i(1, "itemize"),
      i(1, "enumerate"),
      i(1, "description"),
    }),
    t("}"),
    n(2, "[", ""),
    i(2),
    n(2, "]", ""),
    t({ "", "\t\\item " }),
    i(3),
    d(4, rec_enum, {}),
    t({ "", "" }),
    i(5),
    t("\\end{"),
    rep(1),
    t("}"),
  }),

  s("des", {
    t("\\begin{"),
    c(1, {
      i(1, "description"),
      i(1, "enumerate"),
      i(1, "itemize"),
    }),
    t("}"),
    n(2, "[", ""),
    i(2),
    n(2, "]", ""),
    t({ "", "\t" }),
    c(3, {
      {
        t("\t\\item "),
        i(1),
      },
      {
        t("\t"),
        i(1),
      },
    }),
    d(4, rec_enum, {}),
    t({ "", "" }),
    i(5),
    t("\\end{"),
    rep(1),
    t("}"),
  }),
  s("minip", {
    t("\\begin{minipage}"),
    m(2, "%l", "[", ""),
    i(2),
    m(2, "%l", "]", ""),
    t("{"),
    i(1, "0.5"),
    m(1, "[%.%d]+$", "\\textwidth", ""),
    t({ "}", "" }),
    d(3, function(_, snip)
      if snip.env.TM_SELECTED_TEXT == nil then
        return sn(nil, { t("\t"), i(1, "Text") })
      else
        return sn(1, {
          t("\t"),
          isn(1, i(1, snip.env.TM_SELECTED_TEXT), "\t"),
        })
      end
    end, {}),
    t({ "", "\\end{minipage}" }),
    i(4),
  }),

  s("fminip", {
    t({ "\\fbox{", "" }),
    t("\\begin{minipage}"),
    m(2, "%l", "[", ""),
    i(2),
    m(2, "%l", "]", ""),
    t("{"),
    i(1, "0.5"),
    m(1, "[%.%d]+$", "\\textwidth", ""),
    t({ "}", "" }),
    d(3, function(_, snip)
      if snip.env.TM_SELECTED_TEXT == nil then
        return sn(nil, { t("\t"), i(1, "Text") })
      else
        return sn(1, {
          t("\t"),
          isn(1, i(1, snip.env.TM_SELECTED_TEXT), "\t"),
        })
      end
    end, {}),
    t({ "", "\\end{minipage}" }),
    t({ "", "}" }),
    i(4),
  }),
  s("sect", {
    t("\\section{"),
    i(1, "Title"),
    t("}"),
    i(2),
  }),
  s("subsec", {
    t("\\subsection{"),
    i(1, "Title"),
    t("}"),
    i(2),
  }),

  s("scn", {
    t("\\section{"),
    i(1, "Title"),
    t("}"),
    i(2),
  }),

  s("sscn", {
    t("\\subsection{"),
    i(1, "Title"),
    t("}"),
    i(2),
  }),



  s("par", {
    t("\\par"),
    i(1),
  }, {
    condition = function(line, trig, cap)
      local before_char = string.sub(line, -4)
      if before_char ~= "\\par" then
        return true
      end
    end,
  }),

  s("axis", {
    t({
      "\\coordinate (o) at (0, 0);",
      "\\coordinate (-x) at (-5, 0);",
      "\\coordinate (x) at (5, 0);",
      "\\coordinate (-y) at (0, -5);",
      "\\coordinate (y) at (0, 5);",
      "\\draw[Arrow1] (-x) -- (x)",
      "  node[below] {$ x $};",
      "\\draw[Arrow1] (-y) -- (y)",
      "  node[left] {$ y $};",
      "\node[below left] at (o) {$ O $};",
    }),
  }, {
    condition = function(Args)
      if vim.fn["vimtex#syntax#in"]("texTikzZone") == 1 then
        return true
      end
    end,
    show_condition = function(Args)
      if vim.fn["vimtex#syntax#in"]("texTikzZone") == 1 then
        return true
      end
    end,
  }),

  s("d-", {
    t("\\draw"),
    f(function(args, snip)
      local start_char = string.sub(args[1][1], 1, 1)
      local end_char = string.sub(args[1][1], -1, -1)

      if args[1][1] ~= "" and (start_char ~= "[" and end_char ~= "]") then
        return "["
      elseif start_char == "[" and end_char == "]" then
        return ""
      else
        return " "
      end
    end, { 1 }),
    i(1),
    f(function(args, snip)
      local start_char = string.sub(args[1][1], 1, 1)
      local end_char = string.sub(args[1][1], -1, -1)

      if args[1][1] ~= "" and (start_char ~= "[" and end_char ~= "]") then
        return "]"
      elseif start_char == "[" and end_char == "]" then
        return ""
      else
        return ""
      end
    end, { 1 }),
    t(" ("),
    i(2),
    d(3, function(args, snip)
      local match = string.match(args[1][1], "^%d+")
      if match == nil then
        return sn(nil, {
          t(")"),
        })
      else
        return sn(nil, {
          t(", "),
          i(1),
          t(")"),
        })
      end
    end, { 2 }),
    t(" -- ("),
    i(4),
    d(5, function(args, snip)
      local match = string.match(args[1][1], "^%d+")
      if match == nil then
        return sn(nil, {
          t(");"),
        })
      else
        return sn(nil, {
          t(", "),
          i(1),
          t(");"),
        })
      end
    end, { 4 }),
  }, {
    condition = function(Args)
      local a = vim.api.nvim_eval("vimtex#env#is_inside('tikzpicture')")
      if a[2] == 1 then
        return true
      end
    end,
    show_condition = function(Args)
      local a = vim.api.nvim_eval("vimtex#env#is_inside('tikzpicture')")
      if a[2] == 1 then
        return true
      end
    end,
  }),
  s("dcir", {
    t("\\draw ("),
    i(1),
    d(2, function(args, snip)
      local match1 = string.match(args[1][1], "^%d+")

      if match1 == nil then
        return sn(nil, {
          t(")"),
        })
      else
        return sn(nil, {
          t(", "),
          i(1),
          t(")"),
        })
      end
    end, { 1 }),
    t(" circle ("),
    i(3),
    t(");"),
  }, {
    condition = function(Args)
      local a = vim.api.nvim_eval("vimtex#env#is_inside('tikzpicture')")
      if a[2] == 1 then
        return true
      end
    end,
    show_condition = function(Args)
      local a = vim.api.nvim_eval("vimtex#env#is_inside('tikzpicture')")
      if a[2] == 1 then
        return true
      end
    end,
  }),

  s("cod", {
    t("\\coordinate ("),
    i(1),
    t(") at ("),
    i(2),
    t(", "),
    i(3),
    t(");"),
  }, {
    condition = function(Args)
      local a = vim.api.nvim_eval("vimtex#env#is_inside('tikzpicture')")
      if a[2] == 1 then
        return true
      end
    end,
    show_condition = function(Args)
      local a = vim.api.nvim_eval("vimtex#env#is_inside('tikzpicture')")
      if a[2] == 1 then
        return true
      end
    end,
  }),

  s("ar1", {
    t("Arrow1/.style={-stealth, line width=0.8pt, line cap = round}"),
  }, {
    condition = function(Args)
      local a = vim.api.nvim_eval("vimtex#env#is_inside('tikzpicture')")
      if a[2] == 1 then
        return true
      end
    end,
    show_condition = function(Args)
      local a = vim.api.nvim_eval("vimtex#env#is_inside('tikzpicture')")
      if a[2] == 1 then
        return true
      end
    end,
  }),


  s("cubox", {
    t("\\node[below left="),
    i(1, "1cm"),
    t(" of current bounding box.south west] (sw) {};"),
    t({ "", "" }),
    t("\\node[above right="),
    rep(1),
    t(" of current bounding box.north east] (ne) {};"),
    t({ "", "" }),
    t("\\draw [rounded corners="),
    i(2, "0.5cm"),
    t("] (sw) rectangle (ne);"),
  }, {
    condition = function(Args)
      if vim.fn["vimtex#syntax#in"]("texTikzZone") == 1 then
        return true
      end
    end,
    show_condition = function(Args)
      if vim.fn["vimtex#syntax#in"]("texTikzZone") == 1 then
        return true
      end
    end,
  }),

  s("tikzp", {
    t("\\begin{tikzpicture}"),
    m(1, "%l", "[", ""),
    i(1),
    m(1, "%l", "]", ""),
    t({ "", "" }),
    d(2, function(_, snip)
      if snip.env.TM_SELECTED_TEXT == nil or "" then
        return sn(nil, { t("\t"), i(1, "Node") })
      else
        return sn(1, {
          t("\t"),
          isn(1, i(1, snip.env.TM_SELECTED_TEXT), "\t"),
        })
      end
    end, {}),
    t({ "", "\\end{tikzpicture}" }),
    i(3),
  }),

  s("nmin", {
    t("name intersections={of="),
    i(1),
    t(" and "),
    i(2),
    t("}"),
  }, {
    condition = function(Args)
      if vim.fn["vimtex#syntax#in"]("texTikzZone") == 1 then
        return true
      end
    end,
    show_condition = function(Args)
      if vim.fn["vimtex#syntax#in"]("texTikzZone") == 1 then
        return true
      end
    end,
  }),
  s('||', {
    t('| '),
    d(1,
      function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(nil, { i(1, 'Text') })
        else
          return sn(1, {
            i(1, snip.env.TM_SELECTED_TEXT)
          })
        end
      end,
      {}),
    t(' |')
  }, {
    condition = tex.in_text
  }),

  s({
    trig = "vb",
    regTrig = true,
    wordTrig = false,
  }, {
    d(1,
      function(_, snip)
        local select_text = snip.env.TM_SELECTED_TEXT
        if type(select_text) == "table" and next(select_text) ~= nil then
          return sn(nil, {
            t("\\verb|"),
            i(1, select_text),
            t("|"),
          })
        else
          return sn(nil, {
            t("\\verb|"),
            i(1),
            t("|"),
          })
        end
      end)
  }),

  s({
    trig = "ev%.(%a+)",
    regTrig = true,
    wordTrig = false,
  }, {
    t("\\begin{"),
    d(1, function(_, snip)
      if hasCapture(snip.captures) then
        return sn(nil, {
          i(1, snip.captures[1])
        })
      end
      return sn(nil, {
        i(1, "env")
      })
    end),
    t({ "}", "" }),
    d(2, function(_, snip)
      if has_TM_SELECTED_TEXT(snip) then
        return sn(nil, {
          t("\t"),
          isn(1, i(1, snip.env.TM_SELECTED_TEXT), "\t"),
        })
      end
      return sn(nil, {
        t("\t"),
        i(1, "Text")
      })
    end, {}),
    t({ "", "\\end{" }),
    extras.rep(1),
    t("}"),
    i(3)
  }),
  s("vs", create_tex_command("vspace")),
  s("hs", create_tex_command("hspace")),
  s("tbf", create_tex_command("textbf")),
  s("tit", create_tex_command("textit")),
  s({
    trig = "tt",
    wordTrig = false,
  }, create_tex_command("texttt")),
  s("sect", create_tex_command("section")),
  s("bsec", create_tex_command("subsection")),
  s("ssscn", create_tex_command("subsubsection")),
  s("emp", create_tex_command("emph")),
  s("para", create_tex_command("paragraph")),
  s("spara", create_tex_command("subparagraph")),
  s("rm", create_tex_command("mathrm"), {
    condition = tex.in_mathzone,
    show_condition = tex.in_mathzone,
  }),
  s("cha", create_tex_command("chapter")),
  s("ni", create_tex_command("noindent")),

  s("txt", create_tex_command("text"), {
    condition = function()
      -- local toggle = require("core.config.plugins.luasnip.utils").toggle
      -- if toggle == nil then
      -- return vim.fn["vimtex#syntax#in_mathzone"]() == 1
      -- else
      -- return true
      -- end
    end,
    show_condition = function()
      -- local toggle = require("core.config.plugins.luasnip.utils").toggle
      -- if toggle == nil then
      -- return vim.fn["vimtex#syntax#in_mathzone"]() == 1
      -- else
      -- return true
      -- end
    end,
  }),

  s("rm", {
    t("{\\rm "),
    d(1, dynamic_node_select_text),
    t("}"),
  }, {
    condition = tex.in_text,
    show_condition = tex.in_text,
  }),

  s("bf", {
    t("\\mathbf{"),
    d(1, dynamic_node_select_text),
    t("}"),
  }, {
    condition = tex.in_mathzone,
    show_condition = tex.in_mathzone,
  }),

  s("bf", {
    t("{\\bf "),
    d(1, dynamic_node_select_text),
    t("}"),
  }, {
    condition = tex.in_text,
    show_condition = tex.in_text,
  }),

  s("bsy", {
    t("\\boldsymbol{"),
    d(1, dynamic_node_select_text),
    t("}"),
  }, {
    condition = tex.in_mathzone,
    show_condition = tex.in_mathzone,
  }),
}

return snippets
