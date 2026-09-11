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

local function resolve_lua_ls_annotation(snippet, line_to_cursor, matched_trigger, captures)
  local from = line_to_cursor:find("%-*%s*")

  if not from then
    return
  end

  -- from 是 Lua 1-based column
  return {
    clear_region = {
      from = {
        vim.fn.line(".") - 1,
        from - 1,
      },
      to = {
        vim.fn.line(".") - 1,
        #line_to_cursor,
      },
    },
  }
end

--- @param line_to_cursor string
local function only_blank_or_comment_line(line_to_cursor)
  local from = line_to_cursor:find("%-*%s*")
  if not from then
    return false
  end
  return true
end

local snippets = {
  s({
    trig = "--",
    hidden = true,
  }, {
    t({ "--[[", "" }),
    f(function()
      local tab = vim.bo.softtabstop
      return vim.fn["repeat"](" ", tab)
    end),
    i(0),
    t({ "", "--]]" }),
  }),
  s({
    trig = "@version",
    show_condition = only_blank_or_comment_line,
    resolveExpandParams = resolve_lua_ls_annotation,
  }, {
    t("--- @version "),
    i(1),
  }),
  s({ trig = "@type", show_condition = only_blank_or_comment_line }, {
    t("--- @type "),
    i(1, "type"),
  }),
  s({ trig = "@source", show_condition = only_blank_or_comment_line }, {
    t("--- @source "),
    i(1, "path"),
  }),
  s({ trig = "@see", show_condition = only_blank_or_comment_line }, {
    t("--- @see "),
    i(1, "symbol"),
  }),
  s({ trig = "@protected", show_condition = only_blank_or_comment_line }, {
    t("--- @protected"),
  }),
  -- s("@private", {
  --   t("--- @private"),
  -- }),
  s({ trig = "@package", show_condition = only_blank_or_comment_line }, {
    t("--- @package"),
  }),
  s({ trig = "@overload", show_condition = only_blank_or_comment_line }, {
    t("--- @overload fun("),
    i(1),
    t(") "),
    i(2),
  }),
  s({ trig = "@operator", show_condition = only_blank_or_comment_line }, {
    t("--- @operator"),
  }),
  s({ trig = "@nodiscard", show_condition = only_blank_or_comment_line }, {
    t("--- @nodiscard"),
  }),
  s({ trig = "@module", show_condition = only_blank_or_comment_line }, {
    t("--- @module"),
    i(1, "name"),
  }),
  s({ trig = "@meta", show_condition = only_blank_or_comment_line }, {
    t("--- @meta "),
    i(1, "name"),
  }),
  s({ trig = "@generic", show_condition = only_blank_or_comment_line }, {
    t("--- @generic "),
    i(1, "name"),
  }),
  s(
    { trig = "@enum", show_condition = only_blank_or_comment_line },
    c(1, {
      {
        t("--- @enum "),
        i(1, "name"),
      },
      {
        t("--- @enum (key) "),
        i(1, "name"),
      },
    })
  ),
  s({ trig = "@deprecated", show_condition = only_blank_or_comment_line }, {
    t("--- @deprecated"),
  }),
  s({ trig = "@cast", show_condition = only_blank_or_comment_line }, {
    t("--- @cast "),
    i(1, "value"),
    t(" "),
    i(2, "name"),
  }),
  s({ trig = "@async", show_condition = only_blank_or_comment_line }, {
    t("--- @async"),
  }),
  s(
    {
      trig = "@return",
      show_condition = only_blank_or_comment_line,
      resolveExpandParams = resolve_lua_ls_annotation,
    },
    c(1, {
      d(1, function()
        return sn(nil, {
          t("--- @return "),
          i(1, "type"),
          t(" "),
          i(2),
        })
      end),
      d(2, function()
        return sn(nil, {
          t("--- @return "),
          i(1, "type"),
          t(" "),
          i(2, "name"),
          t(" "),
          i(3),
        })
      end),
    })
  ),
  s("@as", {
    t("--[[@as "),
    i(1, "type"),
    t("]]"),
  }),
  s({ trig = "@alias", show_condition = only_blank_or_comment_line }, {
    t("--- @alias "),
    i(1, "name"),
    t(" "),
    i(2, "type"),
  }),
  s({ trig = "@diagnostic", show_condition = only_blank_or_comment_line }, {
    t("--- @diagnostic "),
    i(1),
  }),
  s({ trig = "@field", show_condition = only_blank_or_comment_line }, {
    t("--- @field "),
    i(1, "name"),
    t(" "),
    i(2, "type"),
  }),
  s({ trig = "@class", show_condition = only_blank_or_comment_line }, {
    t("--- @class "),
    i(1),
  }),
  s({
    trig = "@param",
    condition = function(line_to_start)
      if line_to_start:find("%s") then
        return false
      end
      return true
    end,
  }, {
    t("--- @param "),
    i(1, "name"),
    t(" "),
    i(2, "type"),
    t(" "),
    i(3),
  }),
  s("pi", {
    t("print(vim.inspect("),
    i(1),
    t("))"),
  }),
  s({
    trig = "fun",
    regTrig = true,
  }, {
    t("function "),
    i(1),
    t("("),
    i(2),
    t(")"),
    t({ "", "\t" }),
    i(3),
    t({ "", "end" }),
  }),
  s("lc", {
    t("local "),
  }),

  ls.parser.parse_snippet(
    { trig = "prod", name = "product" },
    "\\prod_{${1:n=${2:1}}}^{${3:\\infty}} ${4:${TM_SELECTED_TEXT:text}} $0"
  ),
  s("if", {
    t("if "),
    i(1, "true"),
    t(" then"),
    t({ "", "  " }),
    d(2, function(_, snip)
      if utils.has_TM_SELECTED_TEXT(snip) then
        return sn(nil, { i(1) })
      else
        return sn(1, {
          i(1, snip.env.TM_SELECTED_TEXT),
        })
      end
    end, {}),
    c(3, {
      t(""),
      { t({ "", "else", "\t" }), r(1, "elsetext1") },
      { t({ "", "elseif " }), i(1), t({ " then", "\t" }), r(2, "elsetext1") },
    }),
    c(4, {
      t(" "),
      { t({ "", "else", "\t" }), r(1, "elsetext2") },
      { t({ "", "elseif " }), i(1), t({ " then", "\t" }), r(2, "elsetext2") },
    }),
    c(5, {
      t(" "),
      { t({ "", "else", "\t" }), r(1, "elsetext3") },
      { t({ "", "elseif " }), i(1), t({ " then", "\t" }), r(2, "elsetext3") },
    }),
    t({ "", "end" }),
  }, {
    stored = {
      ["elsetext1"] = i(1),
      ["elsetext2"] = i(1),
      ["elsetext3"] = i(1),
    },
  }),

  s("for", {
    c(1, {
      { t("for "), i(1, "key"), t(", "), i(2, "value"), t(" in pairs("), i(3, "table"), t(") do") },
      { t("for "), i(1, "value"), t(" in pairs("), i(3, "table"), t(") do") },
      { t("for "), i(1, "i"), t(" = "), i(2, "1"), t(" , "), i(3, "10"), t(" do") },
    }),
    t({ "", "\t" }),
    d(2, function(_, snip)
      if utils.has_TM_SELECTED_TEXT(snip) then
        return sn(1, { i(1, "something") })
      else
        return sn(1, i(1, snip.env.TM_SELECTED_TEXT))
      end
    end),
    t({ "", "end" }),
  }),
  s("whi", {
    t("while "),
    i(1, "true"),
    t(" do"),
    t({ "", "\t" }),
    d(2, function(_, snip)
      if utils.has_TM_SELECTED_TEXT(snip) then
        return sn(1, { i(1, "something") })
      else
        return sn(1, i(1, snip.env.TM_SELECTED_TEXT))
      end
    end),
    t({ "", "end" }),
  }),
  s("mm", {
    t({ "local M = {" }),
    i(1),
    t({ "}", "", "" }),
    t("function M"),
    i(2),
    t("("),
    i(3),
    t({ ")", "" }),
    i(4),
    t({ "", "end", "", "" }),
    t("return M"),
  }),

  -- s("dfun", {
  --   t("d("),
  --   i(1, "idx"),
  --   t(", function("),
  --   i(2, "_"),
  --   t(", "),
  --   i(3, "snip"),
  --   t({ ")", "" }),
  --   t("\tif "),
  --   i(4, "next(snip.env.TM_SELECTED_TEXT) == nil"),
  --   t({ " then", "" }),
  --   t("\t\t"),
  --   i(5),
  --   t({ "", "\t\treturn " }),
  --   i(6, 'sn(nil, {i(1, "something")})'),
  --   t({ "", "\telse", "" }),
  --   t("\t\t"),
  --   i(7),
  --   t({ "", "\t\treturn " }),
  --   i(8, "sn(nil, {i(1, snip.env.TM_SELECTED_TEXT)})"),
  --   t({ "", "\tend", "end, {})" }),
  -- }),
}
return snippets

-- like this : $(1: $Visual)
--
--  s('selet',{
--    d(1, function(_, snip)
--      return sn(nil, {
--        i(1, snip.env.TM_SELECTED_TEXT)
--      })
--    end,
--    {})
--  }),

-- like this: $(1:$(Visual: 'Text'))
--    d(2, function(_, snip)
--      if next(snip.env.TM_SELECTED_TEXT) == nil then
--        return sn(nil, {i(1, 'Text')})
--      else
--        return sn(1, {
--          i(1, snip.env.TM_SELECTED_TEXT)
--        })
--      end
--    end,
--    {}),

-- s(
--  "fun",
--  c(1, {
--    {
--      t("function"),
--      extras.nonempty(1, " ", ""),
--      r(1, "funcname"),
--      t("("),
--      r(2, "args"),
--      t(")"),
--      t({ "", "\t" }),
--      r(3, "return"),
--      m(3, "return", " ", ""),
--      r(4, "code"),
--      t({ "", "end" }),
--      i(5),
--    },
--    {
--      t("local "),
--      r(1, "funcname"),
--      t(" = function("),
--      r(2, "args"),
--      t(")"),
--      t({ "", "\t" }),
--      r(3, "return"),
--      m(3, "return", " ", ""),
--      r(4, "code"),
--      t({ "", "end" }),
--      i(5),
--    },
--  }),
--  {
--    stored = {
--      ["funcname"] = i(1),
--      ["args"] = i(2, "Args"),
--      ["return"] = i(3, "return"),
--      ["code"] = i(4),
--    },
--  }
-- ),
--
--
--
