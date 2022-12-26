use std::collections::{HashMap, HashSet};
use std::env;
use std::fs;

#[derive(Debug)]
enum Direction {
    Right,
    Down,
    Left,
    Up,
}

#[derive(Debug)]
struct Blizzard {
    x: i16,
    y: i16,
    dir: Direction,
}

#[derive(Hash, PartialEq, Eq, Debug)]
struct Position {
    x: i16,
    y: i16,
}

fn parse_dir(dir: &str) -> Option<Direction> {
    match dir {
        ">" => Some(Direction::Right),
        "v" => Some(Direction::Down),
        "<" => Some(Direction::Left),
        "^" => Some(Direction::Up),
        _ => None,
    }
}

fn move_blizzards(blizzards: &mut Vec<Blizzard>, width: i16, height: i16) {
    for mut b in blizzards {
        match b.dir {
            Direction::Right => {
                b.x = if b.x == width - 2 { 1 } else { b.x + 1 }
            }
            Direction::Down => {
                b.y = if b.y == height - 2 { 1 } else { b.y + 1 }
            }
            Direction::Left => b.x = if b.x == 1 { width - 2 } else { b.x - 1 },
            Direction::Up => b.y = if b.y == 1 { height - 2 } else { b.y - 1 },
        }
    }
}

fn find(
    from_x: i16,
    from_y: i16,
    to_x: i16,
    to_y: i16,
    blizzards: &mut Vec<Blizzard>,
    width: i16,
    height: i16,
) -> i16 {
    let mut positions = vec![Position {
        x: from_x,
        y: from_y,
    }];
    let mut time = 0;

    loop {
        move_blizzards(blizzards, width, height);

        time += 1;

        let occ: HashSet<Position> = HashSet::from_iter(
            blizzards.iter().map(|b| Position { x: b.x, y: b.y }),
        );

        let mut new_positions: Vec<Position> = Vec::new();
        for pos in &mut positions {
            #[rustfmt::skip]
                let diffs = vec![
                    Position { x: pos.x + 1, y: pos.y },
                    Position { x: pos.x - 1, y: pos.y },
                    Position { x: pos.x, y: pos.y + 1 },
                    Position { x: pos.x, y: pos.y - 1 },
                    Position { x: pos.x, y: pos.y }
                ];

            for diff in diffs {
                if diff.x <= 0 || diff.y < 0 {
                    continue;
                }
                if diff.x == to_x && diff.y == to_y {
                    return time;
                }
                if diff.x == from_x && diff.y == from_y {
                    new_positions.push(diff);
                    continue;
                }
                if diff.y == 0 {
                    continue;
                }
                if diff.x >= width - 1 {
                    continue;
                }
                if diff.y >= height - 1 {
                    continue;
                }

                if !occ.contains(&diff) {
                    new_positions.push(diff);
                }
            }
        }

        let pos_indexes: HashMap<&Position, usize> = HashMap::from_iter(
            new_positions.iter().enumerate().map(|(n, p)| (p, n)),
        );

        positions.clear();

        for (i, pos) in new_positions.iter().enumerate() {
            let index = pos_indexes.get(pos).unwrap();
            if &i == index {
                positions.push(Position { x: pos.x, y: pos.y });
            }
        }
    }
}

fn parse_blizzards(lines: &Vec<String>) -> Vec<Blizzard> {
    let mut blizzards: Vec<Blizzard> = Vec::new();
    for (y, line) in lines.iter().enumerate() {
        for (x, c) in line.split("").enumerate() {
            if let Some(dir) = parse_dir(c) {
                blizzards.push(Blizzard {
                    x: (x - 1).try_into().unwrap(),
                    y: y.try_into().unwrap(),
                    dir,
                })
            }
        }
    }

    blizzards
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let input = fs::read_to_string("./input.txt")?;
    let lines: Vec<String> =
        input.trim().split('\n').map(|s| s.to_string()).collect();

    let mut blizzards = parse_blizzards(&lines);

    let width: i16 = lines[0].len().try_into()?;
    let height: i16 = lines.len().try_into()?;

    let part2 = env::var("part").unwrap_or("part1".into()) == "part2";

    if part2 {
        let first =
            find(1, 0, width - 2, height - 1, &mut blizzards, width, height);
        let second =
            find(width - 2, height - 1, 1, 0, &mut blizzards, width, height);
        let third =
            find(1, 0, width - 2, height - 1, &mut blizzards, width, height);
        let result = first + second + third;
        println!("{:}", result);
    } else {
        let result =
            find(1, 0, width - 2, height - 1, &mut blizzards, width, height);
        println!("{:}", result);
    }

    Ok(())
}
