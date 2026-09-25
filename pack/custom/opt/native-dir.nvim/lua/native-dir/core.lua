local U = require("native-dir.util")
local Buffer = require("native-dir.buffer")

local M = {}

function M.init()
  local ns = vim.api.nvim_create_namespace("native-dir")
  local buffers = {}

  -- vim.fs.no
  vim.api.nvim_create_autocmd("User", {
    pattern = "DirReadPost",
    callback = function(args)
      local id = tostring(args.buf)
      vim.api.nvim_create_autocmd("BufDelete", {
        buf = args.buf,
        callback = function()
          buffers[id] = nil
          return true
        end,
      })
      if not buffers[id] then
        buffers[id] = Buffer.new({ ns = ns, buf = args.buf })
      else
        buffers[id]:reload()
      end
    end,
  })

  local glyph = {
    fifo = "|",
    socket = "=",
    char = "%",
    block = "#",
  }
  vim.api.nvim_set_decoration_provider(ns, {
    on_win = function(_, _, buf)
      return vim.bo[buf].filetype == "directory"
    end,
    on_range = function(_, _, buf, row, _, end_row)
      local dir = vim.api.nvim_buf_get_name(buf)
      local name = vim.api.nvim_buf_get_lines(buf, row, row + 1, true)[1]
      local path = vim.fs.joinpath(dir, (name:gsub("/$", "")))
      local stat = vim.uv.fs_lstat(path) or {}
      local exe = stat.type == "file" and bit.band(stat.mode, tonumber("111", 8)) ~= 0
      local char = glyph[stat.type] or (exe and "*")
      if char then
        vim.api.nvim_buf_set_extmark(buf, ns, row, #name, {
          virt_text = { { char, "Dimmed" } },
          virt_text_pos = "overlay",
          hl_mode = "combine",
          ephemeral = true,
        })
      end
      if stat.type == "link" then
        local target = vim.uv.fs_readlink(path) or "?"
        vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
          virt_text = { { "-> " .. target, "Dimmed" } },
          virt_text_pos = "eol",
          hl_mode = "combine",
          ephemeral = true,
        })
      end
      local size = U.size(stat.size)
      vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
        virt_text = { { size, "Comment" } },
        hl_mode = "combine",
        virt_text_pos = "eol_right_align",
        ephemeral = true,
      })
      -- vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, {
      --   id = 1000,
      --   virt_lines = { { { "Root: " .. dir, "Comment" } } },
      --   virt_lines_above = true,
      --   invalidate = false,
      --   end_row = 1,
      -- })
      local filetype = vim.filetype.match({ filename = name }) or (exe and "exe")
      if filetype then
        local icon, icon_hl = U.get_icon(filetype)
        vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
          id = end_row,
          virt_text = { { icon .. " ", icon_hl } },
          virt_text_pos = "inline",
        })
      end
      return end_row
    end,
  })
end

return M
