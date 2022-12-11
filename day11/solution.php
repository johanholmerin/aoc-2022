<?php

$input = explode("\n", file_get_contents('./input.txt'));
$monkeys = array();

foreach ($input as &$value) {
  $monkey = end($monkeys);
  if (str_contains($value, "Monkey")) {
    $monkey = (object) ["inspections" => 0];
    array_push($monkeys, $monkey);
  } else if (str_contains($value, "Starting")) {
    $monkey->items = array_map('intval', explode(", ", substr($value, 18)));
  } else if (str_contains($value, "Operation")) {
    $monkey->op_value = substr($value, 25);
    $monkey->op_is_add = strcmp($value[23], "*");
  } else if (str_contains($value, "Test")) {
    $monkey->test = intval(substr($value, 21));
  } else if (str_contains($value, "    ")) {
    $target = intval($value[strlen($value) - 1]);
    if (str_contains($value, "true")) $monkey->true_target = $target;
    else $monkey->false_target = $target;
  }
}

$mod = 1;
foreach ($monkeys as &$monkey) $mod *= $monkey->test;

$rounds = getenv("part") === "part2" ? 10000 : 20;
for ($round = 0; $round < $rounds; $round++) {
  foreach ($monkeys as &$monkey) {
    while ($item = array_shift($monkey->items)) {
      $change = $monkey->op_value === "old" ? $item : intval($monkey->op_value);
      if ($monkey->op_is_add) $item += $change;
      else $item *= $change;
      if (getenv("part") === "part2") $item %= $mod;
      else $item = intdiv($item, 3);
      $target = $item % $monkey->test ? $monkey->false_target : $monkey->true_target;
      array_push($monkeys[$target]->items, $item);
      $monkey->inspections++;
    }
  }
}

usort($monkeys, fn ($a, $b) => $b->inspections - $a->inspections);

echo $monkeys[0]->inspections * $monkeys[1]->inspections . PHP_EOL;
