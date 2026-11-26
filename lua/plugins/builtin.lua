vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_difftool = true
vim.g.loaded_undotree_plugin = true

return {
  {
    name = "nvim.difftool",
    cmd = "DiffTool",
    before = function()
      vim.g.loaded_difftool = nil
    end,
  },
  {
    name = "netrw",
    cmd = {
      "Explore",
      "Hexplore",
      "Lexplore",
      "Ntree",
      "Nexplore",
      "Pexplore",
      "Rexplore",
      "Sexplore",
      "Texplore",
      "Vexplore",
    },
    before = function()
      vim.g.loaded_netrw = nil
      vim.g.loaded_netrwPlugin = nil
      -- vim.g.netrw_liststyle = 3
      vim.g.netrw_banner = 0
    end,
    config = function()
      if vim.g.netrw_liststyle ~= 3 then
        local function get_icon(name)
          if name == "directory" then
            return "", "Directory"
          end
          local icon, icon_hl = require("nvim-web-devicons").get_icon_by_filetype(name)
          if not icon then
            icon, icon_hl = require("nvim-web-devicons").get_icon(name)
          end
          if type(icon) == "string" then
            return icon, icon_hl
          end
          return "", "Normal"
        end

        local glyph = {
          fifo = "|",
          socket = "=",
          char = "%",
          block = "#",
        }
        local ns = vim.api.nvim_create_namespace("native-netrw")
        vim.api.nvim_set_decoration_provider(ns, {
          on_win = function(_, _, buf)
            return vim.bo[buf].filetype == "netrw"
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
            -- local size = U.size(stat.size)
            -- vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
            --   virt_text = { { size, "Comment" } },
            --   hl_mode = "combine",
            --   virt_text_pos = "eol_right_align",
            --   ephemeral = true,
            -- })
            -- vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, {
            --   id = 1000,
            --   virt_lines = { { { "Root: " .. dir, "Comment" } } },
            --   virt_lines_above = true,
            --   invalidate = false,
            --   end_row = 1,
            -- })
            local filetype = vim.filetype.match({ filename = name }) or (exe and "exe")
            if filetype then
              local icon, icon_hl = get_icon(filetype)
              vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
                id = end_row,
                virt_text = { { icon .. " ", icon_hl } },
                virt_text_pos = "inline",
              })
            end
            ---@diagnostic disable-next-line: return-type-mismatch
            return end_row
          end,
        })
      end
    end,
  },
  {
    name = "nvim.undotree",
    cmd = "Undotree",
    before = function()
      vim.g.loaded_undotree_plugin = nil
    end,
  },
}
