local lines = {}
for line in io.lines("./input.txt") do
  table.insert(lines, line)
end

local dirs = {}
local names = {}
local names_length = 0;

local function get_path(n)
  local path = "";
  for i, name in pairs(names) do
    if i <= n then
      path = path .. name .. "/"
    end
  end
  return path
end

for _, val in ipairs(lines) do
  if string.sub(val, 1, 5) == "$ cd " then
    local name = string.sub(val, 6)
    if name == ".." then
      table.remove(names, names_length)
      names_length = names_length - 1
    else
      table.insert(names, name)
      local path = get_path(names_length + 1)
      dirs[path] = 0
      names_length = names_length + 1
    end
  elseif string.match(val, "^%d") then
    local size = tonumber(string.match(val, "^%d+"))
    for i in ipairs(names) do
      local path = get_path(i)
      dirs[path] = dirs[path] + size
    end
  end
end

if os.getenv("part") == "part2" then
  local required = 0
  for name, size in pairs(dirs) do
    if name == "//" then
      required = size - 40000000
    end
  end

  local smallest = 70000000
  for _, size in pairs(dirs) do
    if size >= required and size < smallest then
      smallest = size
    end
  end
  print(smallest)
else
  local total = 0
  for _, size in pairs(dirs) do
    if size <= 100000 then
      total = total + size
    end
  end
  print(total)
end
