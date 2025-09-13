local M = {}

local function get_groups()
  local bg = vim.o.background
  local groups = {
    dark = {
      -- Normal = { fg = "#999999", bg = "#191919" },
      Normal = { fg = "#999999", bg = "#000000" },
      Function = { fg = "#605577" },
      Keyword = { fg = "#695C6D" },
      ["@variable"] = { fg = "#808080" },
      -- NormalFloat = { fg = "", bg = "" },
      -- NormalNC = { fg = "", bg = "" },
    },
    light = {},
  }
  return groups[bg]
end

function M.loader()
  vim.cmd("highlight clear")
  vim.o.termguicolors = true
  local groups = get_groups()
  for group, colors in pairs(groups) do
    vim.api.nvim_set_hl(0, group, colors)
  end
end

function M.setup() end

return M

-- black0 = "#000000",
-- black1 = "#0d0d0d",
-- black2 = "#191919",
-- black3 = "#262626",
-- black4 = "#333333",
-- black5 = "#404040",
-- black6 = "#4d4d4d",
-- black7 = "#595959",
-- black8 = "#666666",
-- black9 = "#737373",
-- black10 = "#808080",
-- black11 = "#8C8C8C",
-- black12 = "#999999",
-- black13 = "#A6A6A6",
-- black14 = "#B3B3B3",
-- black15 = "#BFBFBF",
-- black16 = "#CCCCCC",
-- black17 = "#D9D9D9",
-- black18 = "#E6E6E6",
-- black19 = "#F2F2F2",
-- black20 = "#FFFFFF",
--
--
