vim.api.nvim_create_user_command("ChangeDirectoryToFile", function()
  vim.fn.chdir(vim.fn.expand("%:p:h"))
  vim.notify("Changed directory to " .. vim.fn.getcwd())
end, {})

-- -- 创建工作区目录列表
-- local workspaces = {
--   "~/Project",
--   "~/Learn",
--   "~/.config",
--   "~/.config/nvim",
-- }
--
-- -- 使用 fzf-lua 选择工作区
-- vim.api.nvim_create_user_command("Workspace", function()
--   -- 使用回调函数动态加载工作区
--   require("fzf-lua").fzf_exec(function(fzf_cb)
--     for _, workspace in ipairs(workspaces) do
--       fzf_cb(workspace)
--     end
--
--     fzf_cb() -- EOF
--   end, {
--     prompt = "选择工作区: ",
--     actions = {
--       ["default"] = function(selected)
--         local dir = selected[1]
--         vim.fn.chdir(vim.fn.expand(dir))
--         vim.notify("切换到工作区: " .. dir, vim.log.levels.INFO)
--       end,
--     },
--   })
-- end, {})

local function fzf_dirs(opts)
  local fzf_lua = require("fzf-lua")
  opts = opts or {}
  local path = vim.fn.getcwd(0)
  opts.prompt = path .. "> "

  opts.fn_transform = function(x)
    local ansi_codes = require("fzf-lua.utils").ansi_codes
    return ansi_codes.magenta(x)
  end

  opts.fzf_opts = {
    ["--preview"] = "tree {}",
    ["--preview-window"] = "nohidden,down,50%",
  }

  opts.actions = {
    ["default"] = function(selected)
      vim.cmd("cd " .. selected[1])
    end,
  }
  fzf_lua.fzf_exec("fd --type d ", opts)
end

-- local function fzf_dirs_live(opts)
--   local fzf_lua = require("fzf-lua")
--   opts = opts or {}
--   opts.prompt = "Directories> "
--
--   opts.fn_transform = function(x)
--     local ansi_codes = require("fzf-lua.utils").ansi_codes
--     return ansi_codes.magenta(x)
--   end
--
--   opts.fzf_opts = {
--     ["--preview"] = "tree {}",
--     ["--preview-window"] = "right:50%",
--   }
--
--   opts.actions = {
--     ["default"] = function(selected)
--       vim.cmd("cd " .. selected[1])
--     end,
--   }
--
--   -- 使用函数作为内容源
--   fzf_lua.fzf_live(function(query)
--     if query[1] and query[1] ~= "" then
--       return "fd --type d " .. query[1]
--     else
--       return ""
--     end
--   end, opts)
-- end

vim.api.nvim_create_user_command("FzFDirectories", function()
  fzf_dirs()
end, {})
