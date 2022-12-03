import fs from 'fs/promises';
import process from 'node:process';

const input = await fs.readFile('./input.txt', 'utf8');
const lines = input.split('\n');

const sums = [];
let current = 0;
let print_n = 1;

if (process.env.part === 'part2') {
  print_n = 3;
}

for (const line of lines) {
  if (line !== '') {
    current += parseInt(line);
  } else {
    sums.push(current);
    current = 0;
  }
}
sums.push(current);

const sorted_sums = sums.sort((a, b) => b - a).slice(0, print_n);
let total = 0;

for (const line of sorted_sums) {
  total += line;
}

console.log(total);
