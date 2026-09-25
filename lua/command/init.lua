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
--

-- vim.api.nvim_create_user_command("LineConcatInput", function()
--   require("custom.plugins.line-concat").line_concat({
--     trim_blank = false,
--     input = true,
--   })
--   vim.api.nvim_feedkeys("g@", "n", false)
-- end, {
--   range = true,
-- })

-- vim.api.nvim_create_user_command("CodeActions", function()
--   local params = vim.lsp.util.make_range_params(0, "utf-8")
--   params.context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
--   vim.lsp.buf_request_all(0, "textDocument/codeAction", params, function(results)
--     vim.print(results)
--   end)
-- end, {})

-- local function select_tag()
--   local fzf = require("fzf-lua")
--
--   local buf = vim.api.nvim_get_current_buf()
--   fzf.fzf_live(function(args)
--     local tagname = args[1]
--     local items = {}
--     -- vim.schedule(function()
--     vim.api.nvim_buf_call(buf, function()
--       items = {}
--       local tags = vim.fn.taglist("tag")
--       for _, t in ipairs(tags) do
--         table.insert(items, t.filename .. ":" .. t.cmd)
--       end
--     end)
--     -- end)
--     -- if #tags == 0 then
--     --   return
--     -- end
--     -- for _, t in ipairs(tags) do
--     --   local lnum, col = t.cmd:match("\\%%(%d+)l\\%%(%d+)c")
--     --   table.insert(items, t.filename .. ":" .. lnum .. ":" .. col .. ":" .. t.name)
--     -- end
--     return items
--   end, {
--     prompt = "tselect> ",
--     previewer = "builtin",
--   })
--   -- fzf.fzf_exec(items, {
--   --   prompt = "Tags> ",
--   --   -- sink = function(selected)
--   --   --   local file, lnum = selected:match("^(.-):(%d+):")
--   --   --   vim.cmd(string.format("e %s | %d", file, lnum))
--   --   -- end,
--   -- })
-- end

-- local function test()
--   local buf = vim.api.nvim_get_current_buf()
--
--   require("fzf-lua").fzf_live(function(args)
--     local q = args[1]
--     return coroutine.wrap(function(fzf_cb)
--       local co = coroutine.running()
--       vim.schedule(function()
--         vim.api.nvim_buf_call(buf, function()
--           local tags = vim.fn.taglist(q)
--           coroutine.resume(co, tags)
--         end)
--       end)
--       local tags = coroutine.yield()
--       for _, t in ipairs(tags) do
--         local lnum, col = t.cmd:match("\\%%(%d+)l\\%%(%d+)c")
--         local name = t.name
--         local filename = require("fzf-lua").utils.ansi_codes.magenta(t.filename)
--         lnum = require("fzf-lua").utils.ansi_codes.yellow(lnum)
--         col = require("fzf-lua").utils.ansi_codes.yellow(lnum)
--         local item = filename .. ":" .. lnum .. ":" .. col .. ":" .. name
--         item = require("fzf-lua").make_entry.file(item, { file_icons = true, color_icons = true })
--         fzf_cb(item)
--       end
--       fzf_cb()
--     end)
--   end, {
--     prompt = "Tags> ",
--     previewer = "builtin",
--   })
-- end
--
-- vim.api.nvim_create_user_command("SelectTag", function()
--   test()
-- end, {})
--

-- vim.api.nvim_create_user_command("Bufcall", function(args)
--   local command = table.remove(args.fargs, #args.fargs)
--   for _, farg in ipairs(args.fargs) do
--     vim.api.nvim_buf_call(
--       ---@diagnostic disable-next-line: param-type-mismatch
--       tonumber(farg),
--       function()
--         vim.cmd(command)
--       end
--     )
--   end
-- end, {
--   nargs = "*",
--   complete = function()
--     local completions = {}
--     for _, cmd in ipairs(vim.fn.getcompletion("", "buffer")) do
--       table.insert(completions, cmd)
--     end
--     for _, cmd in ipairs(vim.fn.getcompletion("", "command")) do
--       table.insert(completions, cmd)
--     end
--     return completions
--   end,
-- })

my.command.define("Put", "Put", function(args)
  local result = vim.api.nvim_exec2(args.args, { output = true })
  vim.api.nvim_put(vim.split(result.output, "\n", { plain = true }), "l", args.bang and true or false, false)
end, {
  nargs = "*",
  bang = true,
  complete = "command",
})

my.command.define("Bcd", "Bcd", function()
  local path = vim.fn.expand("%:p:h")
  if path ~= nil and vim.uv.fs_stat(path) then
    vim.cmd.bcd(path)
    vim.api.nvim_echo({ { "cwd: " .. vim.fn.getcwd(), "Normal" } }, true, {})
  end
end)
my.command.define("Cd", "Cd", function()
  local path = vim.fn.expand("%:p:h")
  if path ~= nil and vim.uv.fs_stat(path) then
    vim.cmd.cd(path)
    vim.api.nvim_echo({ { "cwd: " .. vim.fn.getcwd(), "Normal" } }, true, {})
  end
end)
my.command.define("Tcd", "Tcd", function()
  local path = vim.fn.expand("%:p:h")
  if path ~= nil and vim.uv.fs_stat(path) then
    vim.cmd.tcd(path)
    vim.api.nvim_echo({ { "cwd: " .. vim.fn.getcwd(), "Normal" } }, true, {})
  end
end)
my.command.define("Lcd", "Lcd", function()
  local path = vim.fn.expand("%:p:h")
  if path ~= nil and vim.uv.fs_stat(path) then
    vim.cmd.lcd(path)
    vim.api.nvim_echo({ { "cwd: " .. vim.fn.getcwd(), "Normal" } }, true, {})
  end
end)

require("command.commands.buffer")
require("command.commands.help")
