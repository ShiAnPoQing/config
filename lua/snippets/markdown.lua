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

local utils = require("luasnip-utils")

return {
  s("cd", {
    d(1, function(_, snip)
      if utils.has_TM_SELECTED_TEXT(snip) then
        return sn(nil, {
          t("~~~"),
          i(1),
          t({ "", "" }),
          i(2, snip.env.TM_SELECTED_TEXT),
          t({ "", "~~~" }),
        })
      else
        return sn(nil, {
          t("~~~"),
          i(1),
          t({ "", "" }),
          i(2),
          t({ "", "~~~" }),
        })
      end
    end, {}),
  }),

  s("@html", {
    d(1, function(_, snip)
      if utils.has_TM_SELECTED_TEXT(snip) then
        return sn(nil, {
          t("~~~html"),
          t({ "", "" }),
          i(1, snip.env.TM_SELECTED_TEXT),
          t({ "", "~~~" }),
        })
      else
        return sn(nil, {
          t("~~~html"),
          t({ "", "" }),
          i(1),
          t({ "", "~~~" }),
        })
      end
    end, {}),
  }),

  s("@css", {
    d(1, function(_, snip)
      if utils.has_TM_SELECTED_TEXT(snip) then
        return sn(nil, {
          t("~~~css"),
          t({ "", "" }),
          i(1, snip.env.TM_SELECTED_TEXT),
          t({ "", "~~~" }),
        })
      else
        return sn(nil, {
          t("~~~css"),
          t({ "", "" }),
          i(1),
          t({ "", "~~~" }),
        })
      end
    end, {}),
  }),
  s("@ps", {
    d(1, function(_, snip)
      if utils.has_TM_SELECTED_TEXT(snip) then
        return sn(nil, {
          t("~~~powershell"),
          t({ "", "" }),
          i(1, snip.env.TM_SELECTED_TEXT),
          t({ "", "~~~" }),
        })
      else
        return sn(nil, {
          t("~~~powershell"),
          t({ "", "" }),
          i(1),
          t({ "", "~~~" }),
        })
      end
    end, {}),
  }),
  s("@c", {
    d(1, function(_, snip)
      if utils.has_TM_SELECTED_TEXT(snip) then
        return sn(nil, {
          t("~~~c"),
          t({ "", "" }),
          i(1, snip.env.TM_SELECTED_TEXT),
          t({ "", "~~~" }),
        })
      else
        return sn(nil, {
          t("~~~c"),
          t({ "", "" }),
          i(1),
          t({ "", "~~~" }),
        })
      end
    end, {}),
  }),
  s("@js", {
    d(1, function(_, snip)
      if utils.has_TM_SELECTED_TEXT(snip) then
        return sn(nil, {
          t("~~~js"),
          t({ "", "" }),
          i(1, snip.env.TM_SELECTED_TEXT),
          t({ "", "~~~" }),
        })
      else
        return sn(nil, {
          t("~~~js"),
          t({ "", "" }),
          i(1),
          t({ "", "~~~" }),
        })
      end
    end, {}),
  }),
  s("@ts", {
    d(1, function(_, snip)
      if utils.has_TM_SELECTED_TEXT(snip) then
        return sn(nil, {
          t("~~~ts"),
          t({ "", "" }),
          i(1, snip.env.TM_SELECTED_TEXT),
          t({ "", "~~~" }),
        })
      else
        return sn(nil, {
          t("~~~ts"),
          t({ "", "" }),
          i(1),
          t({ "", "~~~" }),
        })
      end
    end, {}),
  }),
  s("@cpp", {
    d(1, function(_, snip)
      if utils.has_TM_SELECTED_TEXT(snip) then
        return sn(nil, {
          t("~~~cpp"),
          t({ "", "" }),
          i(1, snip.env.TM_SELECTED_TEXT),
          t({ "", "~~~" }),
        })
      else
        return sn(nil, {
          t("~~~cpp"),
          t({ "", "" }),
          i(1),
          t({ "", "~~~" }),
        })
      end
    end, {}),
  }),
  s("@py", {
    d(1, function(_, snip)
      if utils.has_TM_SELECTED_TEXT(snip) then
        return sn(nil, {
          t("~~~python"),
          t({ "", "" }),
          i(1, snip.env.TM_SELECTED_TEXT),
          t({ "", "~~~" }),
        })
      else
        return sn(nil, {
          t("~~~python"),
          t({ "", "" }),
          i(1),
          t({ "", "~~~" }),
        })
      end
    end, {}),
  }),
  s("@jv", {
    d(1, function(_, snip)
      if utils.has_TM_SELECTED_TEXT(snip) then
        return sn(nil, {
          t("~~~java"),
          t({ "", "" }),
          i(1, snip.env.TM_SELECTED_TEXT),
          t({ "", "~~~" }),
        })
      else
        return sn(nil, {
          t("~~~java"),
          t({ "", "" }),
          i(1),
          t({ "", "~~~" }),
        })
      end
    end, {}),
  }),
}
