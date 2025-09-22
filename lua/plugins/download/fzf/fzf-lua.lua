local tag = require("plugins.download.fzf.tag-keymaps")
local git = require("plugins.download.fzf.git-keymaps")
local live_grep = require("plugins.download.fzf.live-grep-keymaps")
local grep = require("plugins.download.fzf.grep-keymaps")
local lsp = require("plugins.download.fzf.lsp-keymaps")
local complete = require("plugins.download.fzf.complete-keymaps")

local fc = {
  {
    "<leader>fO",
    function()
      require("fzf-lua").resume()
    end,
    desc = "Fzf Resume",
  },
  {
    "<leader>fcc",
    function()
      require("fzf-lua").commands()
    end,
    desc = "Find Commands",
  },
  {
    "<leader>fch",
    function()
      require("fzf-lua").command_history()
    end,
    desc = "Find Commands History",
  },
  {
    "<leader>fcs",
    function()
      require("fzf-lua").colorschemes()
    end,
    desc = "Find Color Schemes",
  },
  {
    "<leader>fcg",
    function()
      require("fzf-lua").changes()
    end,
    desc = "Find Changes",
  },
  {
    "<leader>fcb",
    function()
      require("fzf-lua").combine()
    end,
    desc = "Fzf Combine",
  },
}

local hot = {
  {
    "<leader>ff",
    function()
      require("fzf-lua").files()
    end,
    desc = "Find Files in Current Working Directory",
  },
  {
    "<leader>fb",
    function()
      require("fzf-lua").buffers()
    end,
    desc = "[F]ind [B]uffers",
  },
  {
    "<leader>fll",
    function()
      require("fzf-lua").lines()
    end,
    desc = "Fzf Lines",
  },
  {
    "<leader>flb",
    function()
      require("fzf-lua").blines()
    end,
    desc = "Fzf Lines Buffer",
  },
  {
    "<leader>flo",
    function()
      require("fzf-lua").loclist()
    end,
    desc = "Fzf Loclist",
  },
  {
    "<leader>fts",
    function()
      require("fzf-lua").treesitter()
    end,
    desc = "Fzf Treesitter",
  },
  {
    "<leader>ftb",
    function()
      require("fzf-lua").tabs()
    end,
    desc = "Fzf Tabs",
  },
  {
    "<leader>fag",
    function()
      require("fzf-lua").args()
    end,
    desc = "Fzf Args",
  },
  {
    "<leader>fac",
    function()
      require("fzf-lua").autocmds()
    end,
    desc = "Fzf Autocmds",
  },
  {
    "<leader>fo",
    function()
      require("fzf-lua").oldfiles()
    end,
    desc = "Fzf Old Files",
  },
  {
    "<leader>fq",
    function()
      require("fzf-lua").quickfix()
    end,
    desc = "Fzf Quickfix",
  },
  {
    "<leader>fm",
    function()
      require("fzf-lua").marks()
    end,
    desc = "Fzf Marks",
  },
  {
    "<leader>fss",
    function()
      require("fzf-lua").spell_suggest()
    end,
    desc = "Fzf Spell Suggest",
  },
  {
    "<leader>fsc",
    function()
      require("fzf-lua").spellcheck()
    end,
    desc = "Fzf Spell Check",
  },
  {
    "<leader>fsh",
    function()
      require("fzf-lua").search_history()
    end,
    desc = "Fzf Search History",
  },
  {
    "<leader>fno",
    function()
      require("fzf-lua").nvim_options()
    end,
    desc = "Fzf Neovim Options",
  },
  {
    "<leader>fj",
    function()
      require("fzf-lua").jumps()
    end,
    desc = "Fzf Jumps",
  },
  {
    "<leader>fr",
    function()
      require("fzf-lua").registers()
    end,
    desc = "Fzf Registers",
  },
  {
    "<leader>fk",
    function()
      require("fzf-lua").keymaps()
    end,
    desc = "Fzf Keymaps",
  },
  {
    "<leader>fhl",
    function()
      require("fzf-lua").highlights()
    end,
    desc = "Fzf Highlights",
  },
  {
    "<leader>fht",
    function()
      require("fzf-lua").helptags()
    end,
    desc = "Fzf Helptags",
  },
  {
    "<leader>fz",
    function()
      require("fzf-lua").builtin()
    end,
    desc = "Fzf Builtin",
  },
  {
    "<leader>fg",
    function()
      require("fzf-lua").global()
    end,
    desc = "Fzf Global",
  },
}

local function merge(...)
  local args = { ... }
  local keys = {}

  for _, v in ipairs(args) do
    for _, value in ipairs(v) do
      table.insert(keys, value)
    end
  end

  return keys
end

return {
  "ibhagwan/fzf-lua",
  -- dependencies = { "echasnovski/mini.icons" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  keys = merge(hot, fc, live_grep, lsp, grep, git, tag, complete),
  config = function()
    local fzf = require("fzf-lua")
    vim.api.nvim_create_user_command("FzfFileTypes", function()
      fzf.filetypes()
    end, {})
  end,
}
