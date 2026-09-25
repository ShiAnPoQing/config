local Image = require("native-dir.preview.image")
local Window = require("native-dir.preview.window")
--- @class NativeDir.Preview
local M = {}

--- @class NativeDir.Preview.Opts
--- @field window NativeDir.Preview.Window.Opts
--- @field image NativeDir.Preview.Image.Opts

--- @class NativeDir.Preview.Spec
--- @field file string
--- @field type "image"|"file"

--- @param spec NativeDir.Preview.Spec
--- @param opts NativeDir.Preview.Opts
function M.open(spec, opts)
  if spec.type == "image" then
    Image.open(spec.file, opts.image)
  elseif spec.type == "file" then
    Window.open(spec.file, opts.window)
  end
end

function M.close()
  if Window.is_open() then
    Window.close()
  end
  if Image.is_open() then
    Image.close()
  end
end

--- @return  boolean
function M.is_open()
  if Window.is_open() then
    return true
  end
  if Image.is_open() then
    return true
  end
  return false
end

return M
