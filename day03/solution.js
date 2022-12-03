import fs from 'fs/promises';
import process from 'node:process';

// prettier-ignore
const priorities = [
  'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
]

const input = await fs.readFile('./input.txt', 'utf8');
const lines = input.split('\n');

let sum = 0;
if (process.env.part === 'part2') {
  const packs = ['', '', ''];
  let pack_count = 0;
  for (const line of lines) {
    packs[pack_count] = line;
    pack_count += 1;
    if (pack_count === 3) {
      pack_count = 0;
      outer: for (const a of packs[0]) {
        for (const b of packs[1]) {
          for (const c of packs[2]) {
            if (a === b && b === c) {
              sum += priorities.indexOf(a) + 1;
              break outer;
            }
          }
        }
      }
    }
  }
} else {
  for (const line of lines) {
    const pack_size = line.length / 2;
    const first = line.slice(0, pack_size);
    const second = line.slice(pack_size);
    outer: for (const a of first) {
      for (const b of second) {
        if (a === b) {
          sum += priorities.indexOf(a) + 1;
          break outer;
        }
      }
    }
  }
}
console.log(sum);
