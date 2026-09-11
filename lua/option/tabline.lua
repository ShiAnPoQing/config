--- @class MyTabline.tablabel.Opts
--- @field tabnr integer
--- @field selected? boolean
--- @field event "diagnostic"

local tabline_state = {
  event = nil,
}

local tabline_select_hls = {
  TabLine = "TabLineSel",
  TabLineModified = "TabLineSelModified",
}

local tabline_hls = {
  TabLine = "TabLine",
  TabLineModified = "TabLineModified",
}

--- @return string|nil
local function get_diagnostic_hl(buf)
  local signs = {
    [vim.diagnostic.severity.ERROR] = "DiagnosticError",
    [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
    [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
    [vim.diagnostic.severity.HINT] = "DiagnosticHint",
  }
  for severity, hl_group in pairs(signs) do
    local count = vim.diagnostic.count(buf, { severity = severity })[severity]
    if count and count > 0 then
      return hl_group
    end
  end
end

--- @param opts MyTabline.tablabel.Opts
--- @return string
local function custom_tablabel(opts)
  local tablabel = ""
  local buf = vim.fn.tabpagebuflist(opts.tabnr)[vim.fn.tabpagewinnr(opts.tabnr)]
  local filename = vim.fn.fnamemodify(vim.fn.bufname(buf), ":t")
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
  if filename == "" then
    if filetype == "" then
      filename = "[No Name]"
    end
  end
  local icon, icon_hl = require("nvim-web-devicons").get_icon_by_filetype(filetype)
  local left_pad = " "
  local right_pad = " "

  local hls = tabline_hls
  if opts.selected then
    hls = tabline_select_hls
  end
  local tabline_hl = hls.TabLine
  local state_hl
  if icon and icon_hl then
    state_hl = icon_hl
    filename = icon .. " " .. filename
  end
  local modified = vim.api.nvim_get_option_value("modified", { buf = buf })
  local file_state_icon
  if modified then
    state_hl = hls.TabLineModified
    file_state_icon = ""
  end
  if opts.event == "diagnostic" then
    local diagnostic_hl = get_diagnostic_hl(buf)
    state_hl = diagnostic_hl or state_hl
  end
  state_hl = state_hl and "%$" .. state_hl .. "$" or ""
  tabline_hl = tabline_hl and "%#" .. tabline_hl .. "#" or ""
  file_state_icon = file_state_icon or ""
  local bufnr = "#" .. buf .. " "
  tablabel = tabline_hl .. state_hl .. left_pad .. bufnr .. filename .. file_state_icon .. right_pad
  return tablabel
end

function _G.custom_tabline()
  local tabline = ""
  local cur_tabnr = vim.fn.tabpagenr()

  for i = 1, vim.fn.tabpagenr("$") do
    local tablabel_opts = { tabnr = i, event = tabline_state.event }
    if i == cur_tabnr then
      tablabel_opts.selected = true
    end
    tabline = tabline .. custom_tablabel(tablabel_opts)
  end

  tabline = tabline .. "%#TabLineFill#%T"
  return tabline
end

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    vim.cmd.redrawtabline()
    tabline_state.event = "diagnostic"
  end,
})

vim.o.showtabline = 1
vim.o.tabline = "%!v:lua.custom_tabline()"
