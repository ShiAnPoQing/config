return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
  config = function()
    local logo = [[
    ███████╗██╗  ██╗██╗ █████╗ ███╗   ██╗
    ██╔════╝██║  ██║██║██╔══██╗████╗  ██║
    ███████╗███████║██║███████║██╔██╗ ██║
    ╚════██║██╔══██║██║██╔══██║██║╚██╗██║
    ███████║██║  ██║██║██║  ██║██║ ╚████║
    ╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
    ]]
    logo = string.rep("\n", 3) .. logo .. "\n\n"
    local config = {
      header = vim.split(logo, "\n"),
      center = {
        {
          action = "lua require('fzf-lua').files()",
          desc = " Find File",
          icon = " ",
          key = "f",
        },
        {
          action = "ene | startinsert",
          desc = " New File",
          icon = " ",
          key = "n",
        },
        {
          action = "lua require('fzf-lua').oldfiles()",
          desc = " Recent Files",
          icon = " ",
          key = "r",
        },
        {
          action = "lua require('fzf-lua').live_grep()",
          desc = " Find Text",
          icon = " ",
          key = "g",
        },
        {
          action = "LazyExtras",
          desc = " Lazy Extras",
          icon = " ",
          key = "x",
        },
        {
          action = "Lazy",
          desc = " Lazy",
          icon = "󰒲 ",
          key = "l",
        },
        {
          action = function()
            vim.api.nvim_input("<cmd>qa<cr>")
          end,
          desc = " Quit",
          icon = " ",
          key = "q",
        },
      },
    }
    require("dashboard").setup({
      theme = "doom",
      hide = {
        statusline = false,
      },
      config = config,
    })
    for _, button in ipairs(config.center) do
      button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      button.key_format = "  %s"
    end
    -- open dashboard after closing lazy
    if vim.o.filetype == "lazy" then
      vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(vim.api.nvim_get_current_win()),
        once = true,
        callback = function()
          vim.schedule(function()
            vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
          end)
        end,
      })
    end
  end,
}

-- {
-- 	action = "lua require('telescope.builtin').find_files()",
-- 	desc = " Find File",
-- 	icon = " ",
-- 	key = "f",
-- },
-- {
-- 	action = "ene | startinsert",
-- 	desc = " New File",
-- 	icon = " ",
-- 	key = "n",
-- },
-- {
-- 	action = "lua require('telescope.builtin').oldfiles()",
-- 	desc = " Recent Files",
-- 	icon = " ",
-- 	key = "r",
-- },
-- {
-- 	action = "lua require('telescope.builtin').live_grep()",
-- 	desc = " Find Text",
-- 	icon = " ",
-- 	key = "g",
-- },
-- {
-- 	action = "LazyExtras",
-- 	desc = " Lazy Extras",
-- 	icon = " ",
-- 	key = "x",
-- },
-- {
-- 	action = "Lazy",
-- 	desc = " Lazy",
-- 	icon = "󰒲 ",
-- 	key = "l",
-- },
-- {
-- 	action = function()
-- 		vim.api.nvim_input("<cmd>qa<cr>")
-- 	end,
-- 	desc = " Quit",
-- 	icon = " ",
-- 	key = "q",
-- },
