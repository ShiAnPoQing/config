local exchange = require("custom.plugins.surround.exchange-surround")

return {
  ["cs)"] = {
    function()
      exchange.exchange_surround_match(")")
    end,
    "n",
  },
  ["cs("] = {
    function()
      exchange.exchange_surround_match("(")
    end,
    "n",
  },
  ["cs{"] = {
    function()
      exchange.exchange_surround_match("{")
    end,
    "n",
  },
  ["cs}"] = {
    function()
      exchange.exchange_surround_match("{")
    end,
    "n",
  },
  ["cs["] = {
    function()
      exchange.exchange_surround_match("[")
    end,
    "n",
  },
  ["cs]"] = {
    function()
      exchange.exchange_surround_match("[")
    end,
    "n",
  },
  ["cs<"] = {
    function()
      exchange.exchange_surround_match("<")
    end,
    "n",
  },
  ["cs>"] = {
    function()
      exchange.exchange_surround_match(">")
    end,
    "n",
  },
  ["cs'"] = {
    function()
      exchange.exchange_surround_match("'")
    end,
    "n",
  },
  ['cs"'] = {
    function()
      exchange.exchange_surround_match('"')
    end,
    "n",
  },
}
