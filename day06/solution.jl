file = open("./input.txt")
input = read(file, String)

target = 4
if "part" in keys(ENV) && ENV["part"] == "part2"
  target = 14
end

chars = Array{Char, 1}()
index = 0
for (i, c) in enumerate(input)
  if c in chars
    while chars[1] !== c
      popfirst!(chars)
    end
    popfirst!(chars)
  end
  push!(chars, c)
  if length(keys(chars)) >= target
    global index = i
    break
  end
end

println(index)
close(file)
