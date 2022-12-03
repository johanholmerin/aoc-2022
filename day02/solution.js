import fs from 'fs/promises';
import process from 'node:process';

const input = await fs.readFile('./input.txt', 'utf8');
const lines = input.split('\n');

let score = 0;

for (const line of lines) {
  if (process.env.part === 'part2') {
    if (line == 'A X') score += 3 + 0;
    if (line == 'B X') score += 1 + 0;
    if (line == 'C X') score += 2 + 0;

    if (line == 'A Y') score += 1 + 3;
    if (line == 'B Y') score += 2 + 3;
    if (line == 'C Y') score += 3 + 3;

    if (line == 'A Z') score += 2 + 6;
    if (line == 'B Z') score += 3 + 6;
    if (line == 'C Z') score += 1 + 6;
  } else {
    if (line == 'A X') score += 1 + 3;
    if (line == 'B X') score += 1 + 0;
    if (line == 'C X') score += 1 + 6;

    if (line == 'A Y') score += 2 + 6;
    if (line == 'B Y') score += 2 + 3;
    if (line == 'C Y') score += 2 + 0;

    if (line == 'A Z') score += 3 + 0;
    if (line == 'B Z') score += 3 + 6;
    if (line == 'C Z') score += 3 + 3;
  }
}

console.log(score);
