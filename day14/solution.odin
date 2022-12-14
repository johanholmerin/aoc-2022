package main

import "core:os"
import "core:strings"
import "core:strconv"
import "core:fmt"

main :: proc() {
  grid := [180][800]bool{}
  grid_height := len(grid)
  grid_width := len(grid[0])

	data, ok := os.read_entire_file("./input.txt")
  assert(ok)

	it := string(data)
  max_y := 0
	for line in strings.split_lines_iterator(&it) {
    prev_x := 0
    prev_y := 0
    for part in strings.split(line, " -> ") {
      pos := strings.split(part, ",")
      x := strconv.atoi(pos[0])
      y := strconv.atoi(pos[1])
      if y > max_y { max_y = y }

      grid[y][x] = true
      if (prev_x != 0) {
        curr_x := x
        curr_y := y
        for ; curr_x < prev_x ; curr_x += 1 {
          grid[curr_y][curr_x] = true
        }
        for ; curr_x > prev_x ; curr_x -= 1 {
          grid[curr_y][curr_x] = true
        }
        for ; curr_y < prev_y ; curr_y += 1 {
          grid[curr_y][curr_x] = true
        }
        for ; curr_y > prev_y ; curr_y -= 1 {
          grid[curr_y][curr_x] = true
        }
      }

      prev_x = x;
      prev_y = y;
    }
	}

  if os.get_env("part") == "part2" {
    for x in 0..<grid_width {
      grid[max_y + 2] = true
    }
  }

  count := 0
  sand: for ; !grid[0][500]; count += 1 {
    x := 500
    y := 0
    for !grid[y][x] {
      if y >= grid_height - 1 {
        break sand
      }
      if !grid[y + 1][x] {
        y += 1
        continue
      }
      if x <= 0 || x >= grid_width - 1 {
        break sand
      }
      if !grid[y + 1][x - 1] {
        y += 1
        x -= 1
      } else if !grid[y + 1][x + 1] {
        y += 1
        x += 1
      } else {
        grid[y][x] = true
      }
    }
  }

  fmt.printf("%d\n", count)
}
