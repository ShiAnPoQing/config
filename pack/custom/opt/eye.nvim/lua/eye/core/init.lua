--- @class Eye.Hook.Context
--- @field completed? boolean
--- @field cancelled? boolean
--- @field char? string
--- @field items? Eye.Label.Spec.Item[]
--- @field buf? integer
--- @field data? table<any>

--- @class Eye.Hook
--- @field start? fun(ctx: Eye.Hook.Context)
--- @field finish? fun(ctx: Eye.Hook.Context)
--- @field completed? fun(ctx: Eye.Hook.Context)
--- @field cancelled? fun(ctx: Eye.Hook.Context)

--- @class Eye.Config: Eye.Hook
--- @field labels?  Eye.Label.Spec[]
--- @field layers? Eye.Layer.Spec[]
--- @field label? Eye.Label.Config
--- @field layer? Eye.Layer.Config

local C = require("eye.core.config")
local Layer = require("eye.core.layer")
local Label = require("eye.core.label")
local Root = require("eye.core.tree.root")

--- @class Eye.Gaze
local M = {}

--- @param leaf Eye.Leaf
--- @param spec Eye.Label.Spec
--- @param cfg Eye.Label.Config
local function attach_label_to_leaf(leaf, spec, cfg)
  spec.label = leaf.label --[[@as Eye.Label._Spec]]
  local label = Label:new(
    spec --[[@as Eye.Label._Spec]],
    vim.tbl_deep_extend("force", cfg, {
      extmark = spec.extmark,
      highlight = spec.highlight,
      matched = spec.matched,
    })
  )
  leaf.Label = label
  leaf:on(
    "Highlight",
    --- @param targets Eye.Node[]
    function(targets)
      local texts = {}
      for _, node in ipairs(targets) do
        table.insert(texts, node.label)
      end
      label:highlight(texts)
    end
  )
end

--- @param layers Eye.Layer.Spec[]
--- @param layer Eye.Layer
--- @param root Eye.Root
local function set_default_layers(layers, layer, root)
  layers = layers or {}
  if #layers == 0 then
    for buf in pairs(root.bufs) do
      layers[#layers + 1] = {
        buf = tonumber(buf) --[[@as integer]],
        range = function(ctx)
          return { ctx.topline - 1, ctx.botline }
        end,
      }
    end
  end
  for _, l in ipairs(layers) do
    root.bufs[tostring(l.buf)] = true
  end
  layer.layers = layers
end

--- @param config Eye.Config
function M.gaze(config)
  config = C:resolve(config or {})
  -- local layer = Layer:new({}, config.layer)
  local root = Root:new(config)
  root:on("LeafCreatePost", attach_label_to_leaf)
  -- root:on("BeforeNodeStart", function()
  --   layer:draw()
  -- end)
  -- root:on("BuildPost", function()
  --   set_default_layers(config.layers, layer, root)
  -- end)
  root:build()
  return root
end

return M
