return {
  -- yank/paste/del Outer register text
  ["<space><space>y"] = { '"+y', { "n", "x" } },
  ["<space><space>Y"] = { '"+Y', { "n", "x" } },
  ["<space><space>p"] = { '"+p', { "n", "x" } },
  ["<space><space>P"] = { '"+P', { "n", "x" } },
  ["<space><space>d"] = { '"+d', { "n", "x" } },
}
