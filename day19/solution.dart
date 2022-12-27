import 'dart:io';
import 'dart:math';
import 'dart:convert';

class Blueprint {
  int index;
  int ore_ore_cost;
  int clay_ore_cost;
  int obs_ore_cost;
  int obs_clay_cost;
  int geode_ore_cost;
  int geode_obs_cost;
  Blueprint(
      this.index,
      this.ore_ore_cost,
      this.clay_ore_cost,
      this.obs_ore_cost,
      this.obs_clay_cost,
      this.geode_ore_cost,
      this.geode_obs_cost);
}

class State {
  int time;
  List<int> visited;
  int ore2;
  int clay2;
  int obs2;
  int geo2;
  int ore;
  int clay;
  int obs;
  int geo;
  State(this.time, this.visited, this.ore2, this.clay2, this.obs2, this.geo2,
      this.ore, this.clay, this.obs, this.geo);
}

int maxx(List<int> list) {
  return list.reduce((a, b) => max(a, b));
}

int find(Blueprint blueprint, int time_limit) {
  var max_ore = maxx([
    blueprint.ore_ore_cost,
    blueprint.clay_ore_cost,
    blueprint.obs_ore_cost,
    blueprint.geode_ore_cost
  ]);
  var queue = [State(time_limit, [], 1, 0, 0, 0, 0, 0, 0, 0)];
  var count = 0;

  while (queue.length > 0) {
    final state = queue.removeLast();

    if (state.time == 0) {
      count = max(count, state.geo);
      continue;
    }
    final time = state.time - 1;

    final ore_new = min(state.ore, max_ore * time - state.ore2 * (time - 1));
    final clay_new = min(
        state.clay, blueprint.obs_clay_cost * time - state.clay2 * (time - 1));
    final geode_new = min(
        state.obs, blueprint.geode_obs_cost * time - state.obs2 * (time - 1));

    final ore_max = ore_new >= blueprint.ore_ore_cost;
    final clay_max = ore_new >= blueprint.clay_ore_cost;
    final obs_max = ore_new >= blueprint.obs_ore_cost &&
        clay_new >= blueprint.obs_clay_cost;
    final geode_max = ore_new >= blueprint.geode_ore_cost &&
        geode_new >= blueprint.geode_obs_cost;

    if (ore_new <= max_ore) {
      queue.add(State(
          time,
          [
            if (ore_max) 0,
            if (clay_max) 1,
            if (obs_max) 2,
            if (geode_max) 3,
          ],
          state.ore2,
          state.clay2,
          state.obs2,
          state.geo2,
          ore_new + state.ore2,
          clay_new + state.clay2,
          geode_new + state.obs2,
          state.geo + state.geo2));
    }
    if (state.ore2 < max_ore && ore_max && !state.visited.contains(0)) {
      queue.add(State(
        time,
        [],
        state.ore2 + 1,
        state.clay2,
        state.obs2,
        state.geo2,
        ore_new + state.ore2 - blueprint.ore_ore_cost,
        clay_new + state.clay2,
        geode_new + state.obs2,
        state.geo + state.geo2,
      ));
    }
    if (state.clay2 < blueprint.obs_clay_cost &&
        clay_max &&
        !state.visited.contains(1)) {
      queue.add(State(
        time,
        [],
        state.ore2,
        state.clay2 + 1,
        state.obs2,
        state.geo2,
        ore_new + state.ore2 - blueprint.clay_ore_cost,
        clay_new + state.clay2,
        geode_new + state.obs2,
        state.geo + state.geo2,
      ));
    }
    if (state.obs2 < blueprint.geode_obs_cost &&
        obs_max &&
        !state.visited.contains(2)) {
      queue.add(State(
        time,
        [],
        state.ore2,
        state.clay2,
        state.obs2 + 1,
        state.geo2,
        ore_new + state.ore2 - blueprint.obs_ore_cost,
        clay_new + state.clay2 - blueprint.obs_clay_cost,
        geode_new + state.obs2,
        state.geo + state.geo2,
      ));
    }
    if (geode_max && !state.visited.contains(3)) {
      queue.add(State(
        time,
        [],
        state.ore2,
        state.clay2,
        state.obs2,
        state.geo2 + 1,
        ore_new + state.ore2 - blueprint.geode_ore_cost,
        clay_new + state.clay2,
        geode_new + state.obs2 - blueprint.geode_obs_cost,
        state.geo + state.geo2,
      ));
    }
  }
  return count;
}

void main() async {
  final blueprints = await new File("./input.txt")
      .openRead()
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .map((line) {
    final numbers = RegExp(r'-?[0-9]+')
        .allMatches(line)
        .map((e) => int.parse(e[0]!))
        .toList();

    return Blueprint(numbers[0], numbers[1], numbers[2], numbers[3], numbers[4],
        numbers[5], numbers[6]);
  }).toList();

  String? part = Platform.environment["part"];
  if (part == "part2") {
    final result = blueprints
        .sublist(0, 3)
        .map((bp) => find(bp, 32))
        .reduce((a, b) => a * b);
    print(result);
  } else {
    final result = blueprints
        .map((bp) => find(bp, 24) * bp.index)
        .fold<int>(1, (a, b) => a + b);
    print(result);
  }
}
