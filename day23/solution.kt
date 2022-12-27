import java.io.File

class Elf(var x: Int, var y: Int, var new_x: Int? = null, var new_y: Int? = null)

class Position(var x: Int, var y: Int)

fun get_key(x: Int, y: Int): String {
  return "$x:$y"
}

fun update_current(elves: MutableList<Elf>, current: MutableSet<String>) {
  current.clear()
  elves.forEach { current.add(get_key(it.x, it.y)) }
}

val W = Position(-1, 0)
val NW = Position(-1, -1)
val N = Position(0, -1)
val NE = Position(1, -1)
val E = Position(1, 0)
val SE = Position(1, 1)
val S = Position(0, 1)
val SW = Position(-1, 1)

val MOVES =
    listOf(
        listOf(N, NE, NW),
        listOf(S, SE, SW),
        listOf(W, NW, SW),
        listOf(E, NE, SE),
    )
val DIRECTION_MOVES = mapOf("N" to N, "S" to S, "W" to W, "E" to E)
val DIRECTIONS = listOf("N", "S", "W", "E")
val ALL_MOVES = MOVES.flatten()

fun main() {
  val part2 = System.getenv("part") == "part2"
  val lines = File("input.txt").readLines()
  val elves: MutableList<Elf> = mutableListOf()
  val current: MutableSet<String> = mutableSetOf()

  for ((y, line) in lines.withIndex()) {
    for ((x, c) in line.split("").withIndex()) {
      if (c == "#") {
        elves.add(Elf(x, y))
      }
    }
  }

  update_current(elves, current)

  var moved: Boolean

  var round = 0

  do {
    moved = false
    val proposed_moves: MutableMap<String, Int> = mutableMapOf()

    for_elves@ for (elf in elves) {
      elf.new_x = null
      elf.new_y = null

      val has_neighbor = ALL_MOVES.any { current.contains(get_key(elf.x + it.x, elf.y + it.y)) }
      if (!has_neighbor) continue

      for (i in 0 until 4) {
        val move_i = (i + round) % 4
        val should_move =
            MOVES[move_i].all { !current.contains(get_key(elf.x + it.x, elf.y + it.y)) }
        if (should_move) {
          val move = DIRECTION_MOVES[DIRECTIONS[move_i]]!!
          elf.new_x = elf.x + move.x
          elf.new_y = elf.y + move.y
          val move_key = get_key(elf.new_x!!, elf.new_y!!)
          proposed_moves.getOrPut(move_key) { 0 }
          proposed_moves[move_key] = proposed_moves[move_key]!! + 1
          continue@for_elves
        }
      }
    }
    for (elf in elves) {
      if (elf.new_x == null) continue
      val move_key = get_key(elf.new_x!!, elf.new_y!!)
      if (proposed_moves[move_key]!! > 1) continue
      elf.x = elf.new_x!!
      elf.y = elf.new_y!!
      moved = true
    }

    update_current(elves, current)
    round++
  } while (if (part2) moved else round < 10)

  if (part2) {
    println(round)
  } else {
    val xs = elves.map { it.x }
    val ys = elves.map { it.y }
    val min_x = xs.min()
    val min_y = ys.min()
    val max_x = xs.max()
    val max_y = ys.max()

    val width = max_x - min_x + 1
    val height = max_y - min_y + 1
    println(width * height - elves.size)
  }
}
