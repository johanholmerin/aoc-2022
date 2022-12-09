import fs from 'fs/promises';

const input = await fs.readFile('./input.txt', 'utf8');
const lines = input.trim().split('\n');

const KNOT_COUNT = process.env.part === 'part2' ? 9 : 1;
// [[x, y]]
const VISITED = new Set();
const K_POS = [];
for (let n = 0; n <= KNOT_COUNT; n++) {
  K_POS.push([0, 0]);
}

for (const line of lines) {
  const dir = line.charAt(0);
  let n = parseInt(line.slice(2));

  while (n--) {
    switch (dir) {
      case 'U':
        K_POS[0][1]--;
        break;
      case 'R':
        K_POS[0][0]++;
        break;
      case 'D':
        K_POS[0][1]++;
        break;
      case 'L':
        K_POS[0][0]--;
        break;
    }

    for (let n = 1; n <= KNOT_COUNT; n++) {
      const diffX = K_POS[n][0] - K_POS[n - 1][0];
      const diffY = K_POS[n][1] - K_POS[n - 1][1];

      // Next knot position
      const diff = [diffX, diffY].join('');
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

    VISITED.add(K_POS[K_POS.length - 1].join(','));
  }
}

console.log(VISITED.size);
