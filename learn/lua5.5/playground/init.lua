local t = {}

setmetatable(t, { test = 1 })

for key, value in ipairs(t) do
  print(key, value)
end
print(_VERSION)
