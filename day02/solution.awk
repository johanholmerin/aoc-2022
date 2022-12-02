#!/usr/bin/env awk -F '\n' -f

BEGIN {
  score = 0;
}

{
  if (ENVIRON["part"] == "part2") {
    if ($1 == "A X") score += 3 + 0
    if ($1 == "B X") score += 1 + 0
    if ($1 == "C X") score += 2 + 0

    if ($1 == "A Y") score += 1 + 3
    if ($1 == "B Y") score += 2 + 3
    if ($1 == "C Y") score += 3 + 3

    if ($1 == "A Z") score += 2 + 6
    if ($1 == "B Z") score += 3 + 6
    if ($1 == "C Z") score += 1 + 6
  } else {
    if ($1 == "A X") score += 1 + 3
    if ($1 == "B X") score += 1 + 0
    if ($1 == "C X") score += 1 + 6

    if ($1 == "A Y") score += 2 + 6
    if ($1 == "B Y") score += 2 + 3
    if ($1 == "C Y") score += 2 + 0

    if ($1 == "A Z") score += 3 + 0
    if ($1 == "B Z") score += 3 + 6
    if ($1 == "C Z") score += 3 + 3
  }
}

END {
  print score
}
