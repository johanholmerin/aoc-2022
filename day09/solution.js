import fs from 'fs/promises';

const input = await fs.readFile('./input.txt', 'utf8');
const lines = input.trim().split('\n');

const ROPE_COUNT = process.env.part === 'part2' ? 9 : 1;
// [[x, y]]
const VISITED = [[0, 0]];
const H_POS = [0, 0];
const K_POS = [];
for (let n = 0; n < ROPE_COUNT; n++) {
  K_POS.push([0, 0]);
}

for (const line of lines) {
  const dir = line.charAt(0);
  let n = parseInt(line.slice(2));

  while (n--) {
    switch (dir) {
      case 'U':
        H_POS[1]--;
        break;
      case 'R':
        H_POS[0]++;
        break;
      case 'D':
        H_POS[1]++;
        break;
      case 'L':
        H_POS[0]--;
        break;
      default:
        throw new Error(`Unknown dir ${dir}`);
    }

    for (let n = 0; n < ROPE_COUNT; n++) {
      // Next knot position
      const prev = n ? K_POS[n - 1] : H_POS;
      const diff = `${K_POS[n][0] - prev[0]}${K_POS[n][1] - prev[1]}`;
      switch (diff) {
        case '0-2': // above
          K_POS[n][1]++;
          break;
        case '1-2': // above/right
        case '2-2':
        case '2-1':
          K_POS[n][1]++;
          K_POS[n][0]--;
          break;
        case '-1-2': // above/left
        case '-2-2':
        case '-2-1':
          K_POS[n][1]++;
          K_POS[n][0]++;
          break;
        case '20': // right
          K_POS[n][0]--;
          break;
        case '-20': // left
          K_POS[n][0]++;
          break;
        case '02': // below
          K_POS[n][1]--;
          break;
        case '12': // below/right
        case '22':
        case '21':
          K_POS[n][1]--;
          K_POS[n][0]--;
          break;
        case '-12': // below/left
        case '-22':
        case '-21':
          K_POS[n][1]--;
          K_POS[n][0]++;
          break;
      }
    }

    VISITED.push([...K_POS[K_POS.length - 1]]);
  }
}

const UNIQUE = VISITED.filter((pos) =>
  pos === VISITED.findLast(([x, y]) => pos[0] === x && pos[1] === y)
);
console.log(UNIQUE.length);
