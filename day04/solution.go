package main

import (
	"fmt"
	"os"
	"regexp"
  "strconv"
	"strings"
)

func main() {
	input, err := os.ReadFile("./input.txt")
	if err != nil {
		panic(err)
	}
	lines := strings.Split(string(input), "\n")
	count := 0
	for _, line := range lines {
		if line == "" {
			continue
		}

		sections := regexp.MustCompile(",|-").Split(line, -1);
    var sec [4]int;
    for i, section := range sections {
      value, err := strconv.Atoi(section);
      if err != nil {
        panic(err)
      }
      sec[i] = value
    }

    if os.Getenv("part") == "part2" {
      if sec[1] >= sec[2] && sec[0] <= sec[3] {
        count++
      }
    } else {
      if sec[0] >= sec[2] && sec[1] <= sec[3] {
        count++
      } else if sec[2] >= sec[0] && sec[3] <= sec[1] {
        count++
      }
    }
	}
	fmt.Println(count)
}
