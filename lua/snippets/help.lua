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

local utils = require("snippets.utils")

return {
  s({
    trig = "^==+",
    regTrig = true,
    hidden = true,
    wordTrig = false,
  }, {
    f(function()
      local colorcolumn = vim.wo.colorcolumn
      local start, _end = colorcolumn:find("%d+")
      if start == 1 and _end == #colorcolumn then
        return vim.fn["repeat"]("=", tonumber(colorcolumn) - 1)
      end
    end),
  }),
  s({
    trig = "tg",
  }, {
    t("*"),
    i(1),
    t("*"),
  }),
  s({
    trig = "**",
  }, {
    t("*"),
    i(1),
    t("*"),
  }),
  s({
    trig = "rf",
  }, {
    t("|"),
    i(1),
    t("|"),
  }),
  s({
    trig = "||",
  }, {
    d(1, function(_, snip)
      local function text()
        if type(snip.env.TM_SELECTED_TEXT) == "table" and next(snip.env.TM_SELECTED_TEXT) ~= nil then
          return snip.env.TM_SELECTED_TEXT
        end
      end
      return sn(1, {
        t("|"),
        i(1, text()),
        t("|"),
      })
    end),
  }),
}
