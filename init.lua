require("my")
vim.pack.add({ { src = "https://github.com/BrokenSunny/native-packer", version = "branch" } })
require("operator").setup()
require("window").setup()
require("test").setup()
require("command")
require("global")
require("option")
require("autocmds")
require("keymap").setup()
require("native-packer").add({
  require("plugins.local.neo-lsp"),
  require("plugins.download.style"),
  require("plugins.download.style.statuscol"),
  require("plugins.download.style.lualine"),
  require("plugins.download.misc.nvim-navic"),
  require("plugins.local.native-macro"),
  require("plugins.download.misc.repeat"),
  require("plugins.local.native-diagnostic"),
  require("plugins.local.reasonable-scroll"),
  require("plugins.local.reasonable-screen-move"),
  require("plugins.local.window-swap"),
  require("plugins.local.buffer-swap"),
  require("plugins.download.misc.linefuse"),
  require("plugins.local.move-line"),
  require("plugins.local.move-word"),
  require("plugins.local.cursorline"),
  require("plugins.local.file-details"),
  require("plugins.download.misc.lazydev"),
  -- require("plugins.download.misc.zen"),
  require("plugins.download.git.gitsigns"),
  require("plugins.download.snippet.luasnip"),
  require("plugins.download.cmp.blink-cmp"),
  require("plugins.download.fzf"),
  require("plugins.download.format.conform"),
  require("plugins.download.treesitter"),
  require("plugins.download.filemanager.oil"),
  -- require("plugins.download.filemanager.neo-tree"),
  require("plugins.download.misc.autopairs"),
  require("plugins.download.misc.nvim-ts-autotag"),
  require("plugins.download.misc.supermaven"),
  require("plugins.download.misc.grug-far"),
  require("plugins.download.misc.toggleterm"),
  require("plugins.download.tmux.vim-tmux-navigator"),
  -- require("plugins.download.misc.todo-comments"),
  require("plugins.download.window.winshift"),
  -- require("plugins.download.misc.flash"),
  require("plugins.download.misc.snacks"),
  -- require("plugins.download.misc.trouble"),
  require("plugins.download.tex"),
  require("plugins.download.markdown"),
  require("plugins.download.misc.neotest"),
  -- require("plugins.download.misc.noice"),
  require("plugins.download.misc.outline"),
  require("plugins.download.misc.nvim-web-devicons"),
  require("plugins.local.test.treesitter-textobject"),
  require("plugins.local.test.eye-track-treesitter"),
  require("plugins.local.test.eye"),
  require("plugins.local.doc"),
  -- require("plugins.download.misc.ts-comments"),
  -- require("plugins.download.misc.persistence"),
  -- require("plugins.download.misc.showkey"),
  require("plugins.download.misc.screenkey"),
  require("plugins.download.mini"),
  require("plugins.download.filemanager.yazi"),
  require("plugins.download.misc.misc"),
  -- require("plugins.download.ai.copilot"),
  require("plugins.local.test.bufferman"),
  -- require("plugins.download.ai.opencode"),
  require("plugins.local.test.lsp-layer"),
  -- require("plugins.test.pulseline"),
  -- require("plugins.local.shell-connect"),
  -- require("plugins.test.luma"),
  require("plugins.test.ring"),
  require("plugins.test.window-resize"),
  require("plugins.test._eye"),
  require("plugins.builtin"),
  require("plugins.test.command-proxy"),
  require("plugins.local.native-dir"),
  -- require("plugins.local.neo-tagstack"),
  -- require("plugins.local.visual-move"),
  -- require("plugins.local.bufferman"),
  -- require("plugins.local.test.statusline"),
  -- require("plugins.local.op-register"),
  -- require("plugins.local.simple-translate"),
  -- require("plugins.local.neo-winbar"),
  -- require("plugins.local.test.eye-track"),
})

vim.keymap.set("n", "m/", function()
  local ns = vim.api.nvim_create_namespace("my.search")
  vim.on_key(function(key)
    local input = vim.fn.keytrans(key)
    if input == "<CR>" then
      vim.schedule(function()
        vim.on_key(nil, ns)
        local pattern = vim.fn.getreg("/")
        local cursor = vim.api.nvim_win_get_cursor(0)
        local regex = vim.regex(pattern)
        local total = vim.api.nvim_buf_line_count(0)
        local matches = {}
        local buf = vim.api.nvim_get_current_buf()
        for i = 1, total do
          local start_pos = 0
          while true do
            local start, end_ = regex:match_line(buf, i - 1, start_pos)
            if not start or not end_ or (start == 0 and end_ == 0) then
              break
            end
            table.insert(matches, { line = i, col = start + start_pos, end_col = end_ + start_pos })
            start_pos = start_pos + end_
          end
        end
        for _, m in ipairs(matches) do
          if m.line == cursor[1] and m.col == cursor[2] then
          else
            vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, m.line - 1, m.col, {})
          end
        end
        vim.bo.follow = true
      end)
    end
  end, ns)
  vim.api.nvim_feedkeys("/", "n", true)
end)
