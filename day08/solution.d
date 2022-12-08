import std.stdio, std.string, std.file, std.process;

void main()
{
  auto grid = readText("./input.txt").splitLines();
  auto rows = cast(int) grid.length;
  auto columns = cast(int) grid[0].length;

  if (environment.get("part") == "part2") {
    int score = 0;
    for (int y = 0; y < rows; y++) {
      for (int x = 0;  x < columns; x++) {
        int up = 0;
        for (int y2 = y - 1; y2 >= 0; y2--) {
          up++;
          if (grid[y][x] <= grid[y2][x]) {
            break;
          }
        }

        int down = 0;
        for (int y2 = y + 1; y2 < rows; y2++) {
          down++;
          if (grid[y][x] <= grid[y2][x]) {
            break;
          }
        }

        int left = 0;
        for (int x2 = x - 1; x2 >= 0; x2--) {
          left++;
          if (grid[y][x] <= grid[y][x2]) {
            break;
          }
        }

        int right = 0;
        for (int x2 = x + 1; x2 < columns; x2++) {
          right++;
          if (grid[y][x] <= grid[y][x2]) {
            break;
          }
        }

        auto current = up * left * right * down;
        if (current > score) score = current;
      }
    }

    writeln(score);
  } else {
    int count = 0;
    for (int y = 0; y < rows; y++) {
      for (int x = 0;  x < columns; x++) {
        if (y == 0 || x == 0 || y == columns - 1 || x == rows - 1) {
          count++;
        } else {
          bool findY(int start, int end) {
            for (int y2 = start; y2 < end; y2++) {
              if (grid[y][x] <= grid[y2][x]) {
                return false;
              }
            }
            return true;
          }

          bool findX(int start, int end) {
            for (int x2 = start; x2 < end; x2++) {
              if (grid[y][x] <= grid[y][x2]) {
                return false;
              }
            }
            return true;
          }

          if (
              findY(0, y) ||
              findY(y + 1, rows) ||
              findX(0, x) ||
              findX(x + 1, columns)
             ) {
            count++;
            continue;
          }

        }
      }
    }

    writeln(count);
  }
}
