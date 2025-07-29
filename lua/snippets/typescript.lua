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

local snippets = {
  s("cs", {
    t('<div class="'),
    i(1),
    t('">'),
  }),
  s("und", t("undefined")),
  s("imp", {
    t("import "),
    i(1),
  }),
  s(
    "sT",
    d(1, function(_, snip)
      if utils.has_TM_SELECTED_TEXT(snip) then
        return sn(1, {
          t({ "setTimeout(() => {", "" }),
          i(1),
          t({ "", "}" }),
          i(2),
          t({ ")" }),
        })
      else
        return sn(1, {
          t({ "setTimeout(() => {", "" }),
          i(1, snip.env.TM_SELECTED_TEXT),
          t({ "", "})" }),
        })
      end
    end)
  ),
  s(
    {
      trig = "([%l]*)%.([%l]+)",
      regTrig = true,
      hidden = true,
    },
    d(1, function(_, snip)
      return sn(1, {
        t(snip.captures[1]),
        t("."),
        t(snip.captures[2]),
        t("(("),
        i(1, snip.captures[2]),
        t({ ") => {", "" }),
        i(2),
        t({ "  ", "})" }),
      })
    end)
  ),
  s("fun", {
    t("function "),
    i(1),
    t("("),
    i(2),
    t(") {"),
    t({ "", "\t" }),
    i(3, "return"),
    t({ "", "}" }),
    i(4),
  }),
  -- 临时
  -- s("fun", {
  --   t("function"),
  --   n(1, " ", ""),
  --   i(1, "name"),
  --   t("("),
  --   i(2),
  --   t(") {"),
  --   t({ "", "\t" }),
  --   i(3, "return"),
  --   d(4, function(args)
  --     if args[1][1]:match("return") then
  --       return sn(nil, {
  --         t(" "),
  --         i(1),
  --         t({ "", "}" }),
  --         i(2),
  --         i(3, n(1, "A", "B")),
  --       })
  --     else
  --       return sn(nil, {
  --         t({ "", "}" }),
  --         i(1),
  --       })
  --     end
  --   end, 3),
  -- }, {
  --   callbacks = {
  --     [1] = {
  --       [events.leave] = function(node, args)
  --         if node:get_text()[1]:match("name") then
  --           node:set_text({ "" })
  --         end
  --       end,
  --     },
  --   },
  -- }),

  s("exp", {
    t("export "),
    i(1),
  }),

  s("itf", {
    t("interface "),
    i(1, "Name"),
    t({ " {", "  " }),
    i(2),
    t({ "", "}" }),
  }),

  s("tp", {
    t("type "),
    i(1, "name"),
    t(" = "),
    i(2, "Type"),
  }),

  s("impt", {
    t("import { "),
    i(1, "value"),
    t(' } from "'),
    i(2, "path"),
    t('"'),
    i(3),
  }),

  s("=>", {
    t("("),
    i(1, "param"),
    t({ ") => {", "  " }),
    i(2),
    t({ "", "}" }),
  }),

  s("ext", {
    t("extends "),
    i(1),
  }),

  s(
    "csl",
    d(1, function(_, snip)
      if utils.has_TM_SELECTED_TEXT(snip) then
        return sn(1, { t("console.log("), i(1), t(")") })
      else
        return sn(1, {
          t("console.log("),
          i(1, snip.env.TM_SELECTED_TEXT),
          t(")"),
        })
      end
    end)
  ),

  s("pms", {
    t("new Promise(("),
    i(1, "reslove"),
    t({ ") => {", "\t" }),
    i(2, "reslove(0)"),
    t({ "", "})" }),
    i(3),
  }),
  s("proxy", {
    t("new Proxy({"),
    i(1),
    t({ "}, {", "\t" }),
    t({ "get(target, prop: string) {", "\t" }),
    i(2),
    t({ "", "\t}", "})" }),
    i(3),
  }),
  s("ten", {
    t({ ".then(() => {", "" }),
    isn(1, i(1), "\t"),
    t({ "\t", "})" }),
    i(2),
  }),
}

return snippets
