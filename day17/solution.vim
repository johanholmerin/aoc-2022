set nocompatible

const input = readfile("./input.txt")[0]

let b:rocks = [
  \ [[0, 0], [1, 0], [2, 0], [3, 0]],
  \ [[1, 0], [0, 1], [1, 1], [2, 1], [1, 2]],
  \ [[0, 0], [1, 0], [2, 0], [2, 1], [2, 2]],
  \ [[0, 0], [0, 1], [0, 2], [0, 3]],
  \ [[0, 0], [1, 0], [0, 1], [1, 1]]
\ ]
let b:rock_width = [4, 3, 3, 1, 2]
let b:rock_height = [1, 3, 3, 4, 2]

func Overlap(pos_x, pos_y) abort
  for rock in b:rocks[b:rock_i]
    let x = rock[0] + a:pos_x
    if x >= 7 | return 1 | endif
    if x < 0 | return 1 | endif

    let y = rock[1] + a:pos_y - b:rock_height[b:rock_i]
    if y < 0 | return 1 | endif

    if len(b:cave) > y && index(b:cave[y], x) != -1
      return 1
    endif
  endfor

  return 0
endfunc

let time = 0
let rock_c = 0
let b:rock_i = 0

let b:cave = []

let rep_his = []
let rep_start_c = 0
let rep_start_h = 0
let skipped_h = 0

let target = 2022
if $part == "part2"
  let target = 1000000000000
endif

while rock_c < target
  let pos = [2, len(b:cave) + 3 + b:rock_height[b:rock_i]]

  let rep_key = b:rock_i . ":" . (time % len(input))
  if index(rep_his, rep_key) != -1
    if rep_start_c
      let rep_len_c = rock_c - rep_start_c
      let skip_c = (target - rock_c) / rep_len_c

      let rock_c += rep_len_c * skip_c
      let skipped_h += (len(b:cave) - rep_start_h) * skip_c
    endif

    let rep_his = []
    let rep_start_c = rock_c
    let rep_start_h = len(b:cave)
  endif
  call add(rep_his, rep_key)

  while 1
    let jet = input[time % len(input)]
    if jet == ">"
      if !Overlap(pos[0] + 1, pos[1])
        let pos[0] += 1
      endif
    else
      if !Overlap(pos[0] - 1, pos[1])
        let pos[0] -= 1
      endif
    endif

    let time += 1

    if Overlap(pos[0], pos[1] - 1)
      for rock in b:rocks[b:rock_i]
        let x = rock[0] + pos[0]
        let y = rock[1] + pos[1] - b:rock_height[b:rock_i]
        if len(b:cave) < y + 1
          call add(b:cave, [])
        endif
        call add(b:cave[y], x)
      endfor

      break
    else
      let pos[1] -= 1
    endif
  endwhile

  let rock_c += 1
  let b:rock_i = rock_c % len(b:rocks)
endwhile

call writefile([len(b:cave) + skipped_h], "/dev/stdout")

q
