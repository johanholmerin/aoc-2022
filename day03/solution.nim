import system/io
import std/os

const priorities = [
  'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
]

var sum = 0

if getEnv("part") == "part2":
  var packs = ["", "", ""]
  var pack_count = 0
  for line in lines "input.txt":
    packs[pack_count] = line
    pack_count += 1
    if pack_count == 3:
      pack_count = 0
      block outer:
        for a in packs[0]:
          for b in packs[1]:
            for c in packs[2]:
              if a == b and b == c:
                sum += find(priorities, a) + 1
                break outer
else:
  for line in lines "input.txt":
    var pack_size = (line.len / 2).int
    var first = line[0..pack_size-1]
    var second = line[pack_size..line.len-1]
    block outer:
      for a in first:
        for b in second:
          if a == b:
            sum += find(priorities, a) + 1
            break outer

echo sum
