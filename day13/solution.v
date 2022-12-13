import os
import x.json2

fn is_int(value json2.Any) bool {
	return value.str()[0] != '['[0]
}

fn compare(left &json2.Any, right &json2.Any) int {
	if is_int(*left) && is_int(*right) {
		return left.int() - right.int()
	}

	left_arr := left.arr()
	right_arr := right.arr()

	for i, l in left_arr {
		if i > (right_arr.len - 1) {
			return 1
		}

		res := compare(&l, &right_arr[i])
		if res != 0 {
			return res
		}
	}

	return left_arr.len - right_arr.len
}

file := os.read_file('./input.txt')?.trim_space()

if os.getenv('part') == 'part2' {
	mut input := file.split('\n').filter(it.len)
	dividers := ['[[2]]', '[[6]]']
	input << dividers
	mut lines := input.map(json2.raw_decode(it) or { panic(err) })
	lines.sort_with_compare(compare)
	mut score := 1
	for i, part in lines {
		line := json2.encode(part)
		if line in dividers {
			score *= i + 1
		}
	}
	println(score)
} else {
	mut score := 0
	input := file.split('\n\n')
	for i, part in input {
		parts := part.split_into_lines()
		left := json2.raw_decode(parts[0])!
		right := json2.raw_decode(parts[1])!
		if compare(&left, &right) < 0 {
			score += i + 1
		}
	}
	println(score)
}
