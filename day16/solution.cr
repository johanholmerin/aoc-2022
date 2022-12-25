include Math

alias Valve = {name: String, rate: Int32, tunnels: Array(String)}

class Solver
  def initialize
    part2 = ENV.fetch("part", "part1") == "part2"
    @time = part2 ? 26 : 30
    @valves = {} of String => Valve
    @distances = {} of String => Hash(String, Int32)

    read_input
    calc_paths
    unopened = @valves.values.select { |v| v[:rate] > 0 }
    result = calc_result(
      @time,
      @valves["AA"],
      unopened,
      part2
    )
    puts result
  end

  def read_input
    File.read_lines("./input.txt").each do |line|
      parts = line.split(";")
      name = parts[0][6, 2]
      rate = parts[0][23..].to_i
      tunnels = parts[1][23..].lstrip.split(", ")
      @valves[name] = {name: name, rate: rate, tunnels: tunnels}
    end
  end

  def calc_paths
    @valves.values.each do |valve1|
      @distances[valve1[:name]] = {} of String => Int32
      @valves.values.each do |valve2|
        @distances[valve1[:name]][valve2[:name]] = 100
      end

      @distances[valve1[:name]][valve1[:name]] = 0
      valve1[:tunnels].each do |neighbor|
        @distances[valve1[:name]][neighbor] = 1
      end
    end

    @valves.values.each do |valve1|
      @valves.values.each do |valve2|
        @valves.values.each do |valve3|
          @distances[valve2[:name]][valve3[:name]] = min(
            @distances[valve2[:name]][valve3[:name]],
            @distances[valve2[:name]][valve1[:name]] + @distances[valve1[:name]][valve3[:name]]
          )
        end
      end
    end
  end

  def calc_result(time : Int32, current : Valve, unopened : Array(Valve), first : Bool)
    return 0 if time <= 0

    score = first ? calc_result(@time, @valves["AA"], unopened, false) : 0

    unopened.each_with_index do |valve, index|
      new_time = time - @distances[current[:name]][valve[:name]] - 1
      next if new_time <= 0

      new_unopened = unopened[0...index] + unopened[index + 1...]
      new_result = calc_result(new_time, valve, new_unopened, first)
      score = max(score, valve[:rate] * new_time + new_result)
    end

    return score
  end
end

Solver.new
