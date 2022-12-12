class Main {
  static var grid:Array<String>;
  static var queue:Array<Array<Int>> = [];
  static var visited:Array<String> = [];

	static function main() {
		grid = StringTools.trim(sys.io.File.getContent('./input.txt')).split('\n');
    for (y in 0...grid.length) {
      for (x in 0...grid[y].length) {
        var c = grid[y].charAt(x);
        if (c == 'S' || (Sys.environment()['part'] == 'part2' && c == 'a')) {
          queue.push([x, y, 0]);
        }
      }
    }

    var shortest = 1 / 0;
    while (queue.length != 0) {
      var current = queue.shift();
      var x = current[0], y = current[1], d = current[2];
      var c = grid[y].charAt(x);

      if (d >= shortest) continue;

      if (c == 'E') {
        shortest = d;
        continue;
      }

      if (visited.contains([x, y].join(':'))) continue;
      visited.push([x, y].join(':'));

      if (x != 0) add(x, y, x - 1, y, d);
      if (x != grid[y].length - 1) add(x, y, x + 1, y, d);
      if (y != 0) add(x, y, x, y - 1, d);
      if (y != grid.length - 1) add(x, y, x, y + 1, d);
    }

    haxe.Log.trace(shortest, null);
	}

  static function add(x1:Int, y1:Int, x2:Int, y2:Int, d:Int) {
    var c1 = grid[y1].charAt(x1), c2 = grid[y2].charAt(x2);

    if (c2 == 'E') {
      c2 = 'z';
    }

    if (c1 == 'S' || c1.charCodeAt(0) >= c2.charCodeAt(0) - 1) {
      queue.push([x2, y2, d + 1]);
    }
  }
}
