use "files"
use "collections"

actor Main
  let sensors: Array[(I64, I64, I64)] = Array[(I64, I64, I64)](22)
  let beacons: HashSet[I64, HashIs[I64]] = HashSet[I64, HashIs[I64]]()
  let target_p1: I64 = 2000000
  let target_p2: I64 = 4000000

  new create(env: Env) =>
    let is_part2 = env.vars.contains("part=part2", {(l, r) => l == r})

    try
      var min_x: I64 = 0
      var max_x: I64 = 0

      let file_path = FilePath(FileAuth(env.root), "./input.txt")
      match OpenFile(file_path)
      | let file: File =>
        for line in FileLines(file) do
          let splits: Array[String] = line.string().split("=,:")
          let sensor_x = splits(1)?.i64()?
          let sensor_y = splits(3)?.i64()?
          let beacon_x = splits(5)?.i64()?
          let beacon_y = splits(7)?.i64()?

          let delta = taxi_delta(sensor_x, sensor_y, beacon_x, beacon_y)

          min_x = min(min_x, min(sensor_x, min(beacon_x, sensor_x - delta)))
          max_x = max(max_x, max(sensor_x, max(beacon_x, sensor_x + delta)))

          if beacon_y == target_p1 then beacons.set(beacon_y) end

          sensors.push((sensor_x, sensor_y, delta))
        end
      end

      let result = if is_part2 then part2()? else part1(min_x, max_x) end
      env.out.print(result.string())
    end

  fun part1(min_x: I64, max_x: I64): I64 =>
    var count: I64 = -beacons.size().i64()

    for x in Range[I64](min_x, max_x) do
      for sensor in sensors.values() do
        let d = taxi_delta(sensor._1, sensor._2, x, target_p1)
        if d <= sensor._3 then
          count = count + 1
          break
        end
      end
    end
    count

  fun part2(): I64 ? =>
    for y in Range[I64](0, target_p2 + 1) do
      let spans = Array[(I64, I64)]
      for sensor in sensors.values() do
        let y_distance = abs(sensor._2 - y)
        if y_distance > sensor._3 then continue end

        let delta = sensor._3 - y_distance
        let span = (sensor._1 - delta, sensor._1 + delta)
        insert_sorted(spans, span)?
      end

      for (i, span1) in spans.pairs() do
        for (i2, span2) in spans.pairs() do
          var overlap = false
          if span2._2 <= span1._2 then continue end
          if span2._1 <= span1._2 then
            overlap = true
            break
          end

          if overlap == false then
            return ((span1._2 + 1) * 4000000) + y
          end
        end
      end
    end
    error

  fun taxi_delta(x1: I64, y1: I64, x2: I64, y2: I64): I64 =>
    abs(x1 - x2) + abs(y1 - y2)

  fun min(a: I64, b: I64): I64 =>
    if a > b then b else a end

  fun max(a: I64, b: I64): I64 =>
    if a > b then a else b end

  fun abs(a: I64): I64 =>
    if a < 0 then -a else a end

  fun insert_sorted(spans: Array[(I64, I64)], span: (I64, I64)) ? =>
    var i: USize = 0
    while i < spans.size() do
      if spans(i)?._1 > span._1 then break end
      i = i + 1
    end
    spans.insert(i, span)?
