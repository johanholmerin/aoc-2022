import re
import os

f = open("./input.txt", "r").read()
[c, i] = f.split("\n\n")
crates = []
n = 0
for a in c:
    n = n + 1
    if a == '\n':
        n = 0
    o = (n - 1) // 4
    if len(crates) - 1 < o:
        crates.append([])
    if re.match("[A-Z]", a):
        crates[o].append(a)

for a in i.splitlines(keepends=False):
    [count, start, end] = re.findall('[0-9]+', a)
    tmp = []
    for _ in range(int(count)):
        crate = crates[int(start) - 1].pop(0)
        tmp.append(crate)
    if os.environ.get("part") == "part2":
        tmp.reverse()
    for crate in tmp:
        crates[int(end) - 1].insert(0, crate)

top = "".join(list(map(lambda x: x[0], crates)))
print(top)
