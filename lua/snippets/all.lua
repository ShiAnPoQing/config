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
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key


local util = require("luasnip-utils")

local snippets = {
  s(
    {
      trig = '""',
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t('"'), r(1, "select_text", i(1, "what")), t('"') })
        else
          return sn(1, {
            t('"'),
            r(1, "select_text", i(1, snip.env.TM_SELECTED_TEXT)),
            t('"'),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("'"), r(1, "select_text"), t("'") })
        else
          return sn(1, {
            t("'"),
            r(1, "select_text"),
            t("'"),
          })
        end
      end),

      i(1),
    }, {
      stored = {
        ["select_text"] = i(1),
      },
    })
  ),

  s(
    {
      trig = "“”",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("“"), r(1, "select_text"), t("”") })
        else
          return sn(1, {
            t("‘"),
            r(1, "select_text", i(1, snip.env.TM_SELECTED_TEXT)),
            t("’"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t('"'), r(1, "select_text"), t('"') })
        else
          return sn(1, {
            t('"'),
            r(1, "select_text"),
            t('"'),
          })
        end
      end),

      i(1),
    }, {
      stored = {
        ["select_text"] = i(1),
      },
    })
  ),

  s(
    {
      trig = "‘’",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("‘"), r(1, "select_text"), t("’") })
        else
          return sn(1, {
            t("‘"),
            r(1, "select_text", i(1, snip.env.TM_SELECTED_TEXT)),
            t("’"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("“"), r(1, "select_text"), t("”") })
        else
          return sn(1, {
            t("“"),
            r(1, "select_text"),
            t("”"),
          })
        end
      end),

      i(1),
    }, {
      stored = {
        ["select_text"] = i(1),
      },
    })
  ),

  s(
    {
      trig = "''",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("'"), r(1, "select_text"), t("'") })
        else
          return sn(1, {
            t("'"),
            r(1, "select_text", i(1, snip.env.TM_SELECTED_TEXT)),
            t("'"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t('"'), r(1, "select_text"), t('"') })
        else
          return sn(1, {
            t('"'),
            r(1, "select_text"),
            t('"'),
          })
        end
      end),

      i(1),
    }, {
      stored = {
        ["select_text"] = i(1),
      },
    })
  ),

  s(
    {
      trig = "【】",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("【"), r(1, "select_text"), t("】") })
        else
          return sn(1, {
            t("【"),
            r(1, "select_text", i(1, snip.env.TM_SELECTED_TEXT)),
            t("】"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("["), r(1, "select_text"), t("]") })
        else
          return sn(1, {
            t("["),
            r(1, "select_text"),
            t("]"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("("), r(1, "select_text"), t(")") })
        else
          return sn(1, {
            t("("),
            r(1, "select_text"),
            t(")"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("{"), r(1, "select_text"), t("}") })
        else
          return sn(1, {
            t("{"),
            r(1, "select_text"),
            t("}"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("<"), r(1, "select_text"), t(">") })
        else
          return sn(1, {
            t("<"),
            r(1, "select_text"),
            t(">"),
          })
        end
      end),

      i(1),
    }, {
      stored = {
        ["select_text"] = i(1),
      },
    })
  ),

  s(
    {
      trig = "%[%]",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("["), r(1, "select_text"), t("]") })
        else
          return sn(1, {
            t("["),
            r(1, "select_text", i(1, snip.env.TM_SELECTED_TEXT)),
            t("]"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("("), r(1, "select_text"), t(")") })
        else
          return sn(1, {
            t("("),
            r(1, "select_text"),
            t(")"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("{"), r(1, "select_text"), t("}") })
        else
          return sn(1, {
            t("{"),
            r(1, "select_text"),
            t("}"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("<"), r(1, "select_text"), t(">") })
        else
          return sn(1, {
            t("<"),
            r(1, "select_text"),
            t(">"),
          })
        end
      end),

      i(1),
    }, {
      stored = {
        ["select_text"] = i(1),
      },
    })
  ),

  s(
    {
      trig = "{}",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("{"), r(1, "select_text"), t("}") })
        else
          return sn(1, {
            t("{"),
            r(1, "select_text", i(1, snip.env.TM_SELECTED_TEXT)),
            t("}"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("("), r(1, "select_text"), t(")") })
        else
          return sn(1, {
            t("("),
            r(1, "select_text"),
            t(")"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("["), r(1, "select_text"), t("]") })
        else
          return sn(1, {
            t("["),
            r(1, "select_text"),
            t("]"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("<"), r(1, "select_text"), t(">") })
        else
          return sn(1, {
            t("<"),
            r(1, "select_text"),
            t(">"),
          })
        end
      end),

      i(1),
    }, {
      stored = {
        ["select_text"] = i(1),
      },
    })
  ),
  s(
    {
      trig = "%(%)",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    d(1, function(_, snip)
      local function text()
        if type(snip.env.TM_SELECTED_TEXT) == "table" and next(snip.env.TM_SELECTED_TEXT) ~= nil then
          return snip.env.TM_SELECTED_TEXT
        end
        return "select_text"
      end
      return sn(1, { t("("), i(1, text()), t(")") })
    end)
  ),

  -- s(
  --   {
  --     trig = "%(%)",
  --     regTrig = true,
  --     hidden = true,
  --     wordTrig = false,
  --   },
  --   c(1, {
  --     d(1, function(_, snip)
  --       if next(snip.env.TM_SELECTED_TEXT) == nil then
  --         return sn(1, { t("("), r(1, "select_text"), t(")") })
  --       else
  --         return sn(1, {
  --           t("("),
  --           r(1, "select_text", i(1, snip.env.TM_SELECTED_TEXT)),
  --           t(")"),
  --         })
  --       end
  --     end),
  --     d(1, function(_, snip)
  --       if next(snip.env.TM_SELECTED_TEXT) == nil then
  --         return sn(1, { t("["), r(1, "select_text"), t("]") })
  --       else
  --         return sn(1, {
  --           t("["),
  --           r(1, "select_text"),
  --           t("]"),
  --         })
  --       end
  --     end),
  --     d(1, function(_, snip)
  --       if next(snip.env.TM_SELECTED_TEXT) == nil then
  --         return sn(1, { t("{"), r(1, "select_text"), t("}") })
  --       else
  --         return sn(1, {
  --           t("{"),
  --           r(1, "select_text"),
  --           t("}"),
  --         })
  --       end
  --     end),
  --     d(1, function(_, snip)
  --       if next(snip.env.TM_SELECTED_TEXT) == nil then
  --         return sn(1, { t("<"), r(1, "select_text"), t(">") })
  --       else
  --         return sn(1, {
  --           t("<"),
  --           r(1, "select_text"),
  --           t(">"),
  --         })
  --       end
  --     end),
  --
  --     i(1),
  --   }, {
  --     stored = {
  --       ["select_text"] = i(1),
  --     },
  --   })
  -- ),

  s(
    {
      trig = "<>",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("<"), r(1, "select_text"), t(">") })
        else
          return sn(1, {
            t("<"),
            r(1, "select_text", i(1, snip.env.TM_SELECTED_TEXT)),
            t(">"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("("), r(1, "select_text"), t(")") })
        else
          return sn(1, {
            t("("),
            r(1, "select_text"),
            t(")"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("["), r(1, "select_text"), t("]") })
        else
          return sn(1, {
            t("["),
            r(1, "select_text"),
            t("]"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("{"), r(1, "select_text"), t("}") })
        else
          return sn(1, {
            t("{"),
            r(1, "select_text"),
            t("}"),
          })
        end
      end),

      i(1),
    }, {
      stored = {
        ["select_text"] = i(1),
      },
    })
  ),

  s(
    {
      trig = "《》",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("《"), r(1, "select_text"), t("》") })
        else
          return sn(1, {
            t("《"),
            r(1, "select_text", i(1, snip.env.TM_SELECTED_TEXT)),
            t("》"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("<"), r(1, "select_text"), t(">") })
        else
          return sn(1, {
            t("<"),
            r(1, "select_text"),
            t(">"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("("), r(1, "select_text"), t(")") })
        else
          return sn(1, {
            t("("),
            r(1, "select_text"),
            t(")"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("["), r(1, "select_text"), t("]") })
        else
          return sn(1, {
            t("["),
            r(1, "select_text"),
            t("]"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("{"), r(1, "select_text"), t("}") })
        else
          return sn(1, {
            t("{"),
            r(1, "select_text"),
            t("}"),
          })
        end
      end),

      i(1),
    }, {
      stored = {
        ["select_text"] = i(1),
      },
    })
  ),

  s(
    {
      trig = "（）",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("（"), r(1, "select_text"), t("）") })
        else
          return sn(1, {
            t("（"),
            r(1, "select_text", i(1, snip.env.TM_SELECTED_TEXT)),
            t("）"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("("), r(1, "select_text"), t(")") })
        else
          return sn(1, {
            t("("),
            r(1, "select_text"),
            t(")"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("["), r(1, "select_text"), t("]") })
        else
          return sn(1, {
            t("["),
            r(1, "select_text"),
            t("]"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("{"), r(1, "select_text"), t("}") })
        else
          return sn(1, {
            t("{"),
            r(1, "select_text"),
            t("}"),
          })
        end
      end),
      d(1, function(_, snip)
        if next(snip.env.TM_SELECTED_TEXT) == nil then
          return sn(1, { t("<"), r(1, "select_text"), t(">") })
        else
          return sn(1, {
            t("<"),
            r(1, "select_text"),
            t(">"),
          })
        end
      end),

      i(1),
    }, {
      stored = {
        ["select_text"] = i(1),
      },
    })
  ),

  s(
    {
      trig = "【】([%a%d]+)",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        return sn(1, { t("【"), r(1, "captures1", i(nil, snip.captures[1])), t("】") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("["), r(1, "captures1"), t("]") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("("), r(1, "captures1"), t(")") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("{"), r(1, "captures1"), t("}") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { r(1, "captures1") })
      end, {}),
      i(1),
    }, {
      stored = {
        ["captures1"] = i(1),
      },
    })
  ),

  s(
    {
      trig = "%[%]([%a%d]+)",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        return sn(1, { t("["), r(1, "captures1", i(nil, snip.captures[1])), t("]") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("("), r(1, "captures1"), t(")") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("{"), r(1, "captures1"), t("}") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("<"), r(1, "captures1"), t(">") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { r(1, "captures1") })
      end, {}),
      i(1),
    }, {
      stored = {
        ["captures1"] = i(1),
      },
    })
  ),

  s(
    {
      trig = "{}([%a%d]+)",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        return sn(1, { t("{"), r(1, "captures1", i(nil, snip.captures[1])), t("}") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("["), r(1, "captures1"), t("]") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("("), r(1, "captures1"), t(")") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("<"), r(1, "captures1"), t(">") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { r(1, "captures1") })
      end, {}),
      i(1),
    }, {
      stored = {
        ["captures1"] = i(1),
      },
    })
  ),
  s(
    {
      trig = "%(%)([%a%d]+)",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        return sn(1, { t("("), r(1, "captures1", i(nil, snip.captures[1])), t(")") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("{"), r(1, "captures1"), t("}") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("["), r(1, "captures1"), t("]") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("<"), r(1, "captures1"), t(">") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { r(1, "captures1") })
      end, {}),
      i(1),
    }, {
      stored = {
        ["captures1"] = i(1),
      },
    })
  ),

  s(
    {
      trig = "<>([%a%d]+)",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        return sn(1, { t("<"), r(1, "captures1", i(nil, snip.captures[1])), t(">") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("{"), r(1, "captures1"), t("}") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("["), r(1, "captures1"), t("]") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("("), r(1, "captures1"), t(")") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { r(1, "captures1") })
      end, {}),
      i(1),
    }, {
      stored = {
        ["captures1"] = i(1),
      },
    })
  ),

  s(
    {
      trig = "《》([%a%d]+)",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        return sn(1, { t("《"), r(1, "captures1", i(nil, snip.captures[1])), t("》") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("<"), r(1, "captures1", i(nil, snip.captures[1])), t(">") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("{"), r(1, "captures1"), t("}") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("["), r(1, "captures1"), t("]") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("("), r(1, "captures1"), t(")") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { r(1, "captures1") })
      end, {}),
      i(1),
    }, {
      stored = {
        ["captures1"] = i(1),
      },
    })
  ),

  s(
    {
      trig = "（）([%a%d]+)",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        return sn(1, { t("（"), r(1, "captures1", i(nil, snip.captures[1])), t("）") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("("), r(1, "captures1"), t(")") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("<"), r(1, "captures1", i(nil, snip.captures[1])), t(">") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("{"), r(1, "captures1"), t("}") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("["), r(1, "captures1"), t("]") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { r(1, "captures1") })
      end, {}),
      i(1),
    }, {
      stored = {
        ["captures1"] = i(1),
      },
    })
  ),

  s(
    {
      trig = "''([%a%d]+)",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        return sn(1, { t("'"), r(1, "captures1", i(nil, snip.captures[1])), t("'") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t('"'), r(1, "captures1"), t('"') })
      end, {}),
      i(1),
    }, {
      stored = {
        ["captures1"] = i(1),
      },
    })
  ),

  s(
    {
      trig = '""([%a%d]+)',
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        return sn(1, { t('"'), r(1, "captures1"), t('"') })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("'"), r(1, "captures1", i(nil, snip.captures[1])), t("'") })
      end, {}),
      i(1),
    }, {
      stored = {
        ["captures1"] = i(1),
      },
    })
  ),

  s(
    {
      trig = "‘’([%a%d]+)",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        return sn(1, { t("‘"), r(1, "captures1", i(nil, snip.captures[1])), t("’") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("'"), r(1, "captures1"), t("'") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("“"), r(1, "captures1"), t("”") })
      end, {}),
      i(1),
    }, {
      stored = {
        ["captures1"] = i(1),
      },
    })
  ),

  s(
    {
      trig = "“”([%a%d]+)",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        return sn(1, { t("“"), r(1, "captures1", i(nil, snip.captures[1])), t("”") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t('"'), r(1, "captures1"), t('"') })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("'"), r(1, "captures1"), t("'") })
      end, {}),
      i(1),
    }, {
      stored = {
        ["captures1"] = i(1),
      },
    })
  ),

  s(
    {
      trig = "【】([%a%d]+)%s",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    c(1, {
      d(1, function(_, snip)
        return sn(1, { t("【"), r(1, "captures1", i(nil, snip.captures[1])), t("】") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { t("["), r(1, "captures1"), t("]") })
      end, {}),
      d(1, function(_, snip)
        return sn(1, { r(1, "captures1") })
      end, {}),
      i(1),
    }, {
      stored = {
        ["captures1"] = i(1),
      },
    })
  ),

  s(
    {
      trig = "\\([a-zA-Z]+)%[%]%{%}([a-zA-Z]+)(%s%s)([a-zA-Z]+)",
      regTrig = true,
      hidden = true,
      wordTrig = false,
    },
    f(function(args, snip)
      if snip.captures[4] then
        return "\\" .. snip.captures[1] .. "[" .. snip.captures[2] .. "]" .. "{" .. snip.captures[4] .. "}"
      else
        return "\\" .. snip.captures[1] .. "{" .. snip.captures[2] .. "}"
      end
    end)
  ),

  --       s({
  --         trig = "\\([a-zA-Z]+)%s%s([^%s]+)",
  --         regTrig = true,
  --         hidden = true,
  --         wordTrig = false,
  --       },
  --       d(1,
  --       function(_, snip)
  --         return
  --         sn(nil, {t('\\'),
  --         c(1,{
  --           sn(1, {t(snip.captures[1]), t('{'), r(1, 'captures2', i(nil, snip.captures[2])),  t('}')}),
  --           sn(2, {t(snip.captures[1]), t('['), r(1, 'captures2'), t(']')}),
  --           sn(3, {i(1, snip.captures[1])})
  --         }, {
  --           stored = {
  --             ['captures2'] = i(1)
  --           }
  --         })
  --       })
  --     end)
  --     ),

  --   s({
  --     trig = "\\([a-zA-Z]+)%s%s([^%s%]%[%{%}]+)%s%s([^%s%]%[%{%}]+)",
  --     regTrig = true,
  --     hidden = true,
  --     wordTrig = false,
  --   },
  --   d(1,
  --   function(_, snip)
  --     return
  --     sn(nil, {t('\\'),
  --     c(1,{
  --       sn(1, {t(snip.captures[1]), t('['), r(1, 'captures2', i(nil, snip.captures[2])),  t(']{'), r(2, 'captures3', i(nil, snip.captures[3])), t('}')}),
  --       sn(2, {t(snip.captures[1]), t('{'), r(1, 'captures2'), t('}{'), r(2, 'captures3'), t('}')}),
  --       sn(3, i(1, snip.captures[1]))
  --     }, {
  --       stored = {
  --         ['captures2'] = i(1),
  --         ['captures3'] = i(1)
  --       }
  --     })
  --   })
  -- end)
  -- ),

  --  USE:
  --  \ABC[]{}|  -> <Tab>
  --  \ABC[]{|}

  --  \ABC[]{} | -> <Tab>
  --  \ABC[|]{}  -> <Tab>
  --  \ABC[]{|}  -> <Tab>
  s({
    trig = "\\([a-zA-Z]+)%[%]%{%}%s",
    regTrig = true,
    wordTrig = false,
    hidden = true
  }, {
    t("\\"),
    f(function(args, snip)
      return snip.captures[1]
    end),
    t("["),
    i(1),
    t("]{"),
    i(2),
    t("}"),
    i(3),
  }),

  s({
    trig = "([a-zA-Z]+)\\",
    regTrig = true,
    wordTrig = false,
    hidden = true
  }, {
    t("\\"),
    f(function(args, snip)
      return snip.captures[1]
    end),
  }),

  s("re", {
    t("return"),
    i(1),
  }),

  s("**", {
    t({ "/**", "* " }),
    i(1),
    t({ "", "*/" }),
    i(2),
  }),

  s("false", {
    t("true"),
    i(1)
  }),
  s("true", {
    t("false"),
    i(1)
  }),

  -- insert mode register p
  s({
    trig = "%.(%w)",
    regTrig = true,
    hidden = true,
  }, {
    f(function(args, snip)
      local text = vim.fn.getreg(snip.captures[1])
      return text
    end, {}),
  }),
}

return snippets

--  s({
--    trig = '([%[%{%<%(])([%]%}%>%)])',
--    hidden = true,
--    regTrig = true,
--    wordTrig = false
--  }, c(1, { d(1,
--  function(_, snip)
--    if snip.captures[1] == '[' and
--      snip.captures[2] == ']' or
--      (snip.captures[1] == '{' and snip.captures[2] == '}') or
--      (snip.captures[1] == '(' and snip.captures[2] == ')') or
--      (snip.captures[1] == '<' and snip.captures[2] == '>')
--      then

--        if
--          next(snip.env.TM_SELECTED_TEXT) == nil then
--          return sn(1,{t(snip.captures[1]), i(1), t(snip.captures[2])})
--        else return sn(1,
--          {t(snip.captures[1]), i(1, snip.env.TM_SELECTED_TEXT),
--          t(snip.captures[2])})
--        end
--      end
--    end), i(2) })
--    ),
--
--
--
--
--  s({
--    trig = "([%[%{%<%(])([%]%}%>%)])([a-zA-Z0-9]+)",
--    regTrig = true,
--    hidden = true,
--    wordTrig = false},
--    c(1, {
--      d(1,function(args, snip)
--
--        if (snip.captures[1] == '[' and snip.captures[2] == ']'
--          or (snip.captures[1] == '{' and snip.captures[2] == '}')
--          or (snip.captures[1] == '(' and snip.captures[2] == ')')
--          or (snip.captures[1] == '<' and snip.captures[2] == '>'))
--          then
--            return
--            sn(nil ,{t(snip.captures[1]), i(1, snip.captures[3]), t(snip.captures[2])})
--          else
--            return
--            sn(nil, {t(snip.captures[1]), t(snip.captures[2]), t(snip.captures[3])})
--          end
--        end),
--
--      })
--      ),
