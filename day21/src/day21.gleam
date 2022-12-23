import gleam/erlang/file
import gleam/erlang/os
import gleam/io
import gleam/int
import gleam/list
import gleam/string
import gleam/result
import gleam/map

pub type Value {
  Human(value: Int)
  Value(value: Int)
  Op(op: String, left: Value, right: Value, has_x: Bool)
}

pub type Values =
  map.Map(String, String)

fn calc(value: Value) -> Int {
  case value {
    Value(int) -> int
    Human(int) -> int
    Op("+", left, right, _) -> calc(left) + calc(right)
    Op("-", left, right, _) -> calc(left) - calc(right)
    Op("*", left, right, _) -> calc(left) * calc(right)
    Op("/", left, right, _) -> calc(left) / calc(right)
  }
}

fn get(values: Values, name: String) -> Result(Value, Nil) {
  try prop = map.get(values, name)
  let int_res = int.parse(prop)

  case name, prop, int_res {
    "humn", _, Ok(int) -> Ok(Human(int))
    _, _, Ok(int) -> Ok(Value(int))
    _, prop, _ -> {
      let [left, op, right] = string.split(prop, " ")
      try left_value = get(values, left)
      try right_value = get(values, right)
      let has_x = case left_value, right_value {
        Human(_), _ -> True
        _, Human(_) -> True
        _, Op(_, _, _, True) -> True
        Op(_, _, _, True), _ -> True
        _, _ -> False
      }
      Ok(Op(op, left_value, right_value, has_x))
    }
  }
}

fn part1(values: Values) -> Result(Int, Nil) {
  get(values, "root")
  |> result.map(calc)
}

fn reduce(left: Value, right: Value) -> #(Value, Value) {
  let keep_left = case left {
    Op(_, Op(_, _, _, has_x), _, _) -> has_x
    Op(_, Human(_), _, _) -> True
    _ -> False
  }

  case keep_left, left {
    _, Value(_) -> #(left, right)
    _, Human(_) -> #(left, right)

    True, Op("+", l, r, _) -> reduce(l, Op("-", right, r, False))
    False, Op("+", r, l, _) -> reduce(l, Op("-", right, r, False))

    True, Op("-", l, r, _) -> reduce(l, Op("+", r, right, False))
    False, Op("-", r, l, _) -> reduce(l, Op("-", r, right, False))

    True, Op("*", l, r, _) -> reduce(l, Op("/", right, r, False))
    False, Op("*", r, l, _) -> reduce(l, Op("/", right, r, False))

    True, Op("/", l, r, _) -> reduce(l, Op("*", right, r, False))
    False, Op("/", r, l, _) ->
      reduce(l, Op("/", Value(1), Op("/", right, r, False), False))
  }
}

fn part2(values: Values) -> Result(Int, Nil) {
  assert Ok(Op(_, left, right, _)) = get(values, "root")
  let #(_, res_right) = reduce(left, right)
  Ok(calc(res_right))
}

pub fn main() {
  let part = os.get_env("part")
  assert Ok(input) = file.read("./input.txt")
  let values =
    input
    |> string.trim
    |> string.split("\n")
    |> list.map(string.split(_, ": "))
    |> list.map(fn(l) {
      let [name, values] = l
      #(name, values)
    })
    |> map.from_list

  assert Ok(result) = case part {
    Ok("part2") -> part2(values)
    _ -> part1(values)
  }

  io.println(int.to_string(result))
}
