import ballerina/os;
import ballerina/regex;
import ballerina/io;

const RIGHT = 0;
const DOWN = 1;
const LEFT = 2;
const UP = 3;

type Move record {
    int length;
    string dir;
};

type Pos [int, int, int];

function mod(int x, int m) returns int {
    return (x % m + m) % m;
}

function get_square(string[] lines, int x, int y) returns string {
    if (y >= lines.length() || y < 0) {
        return " ";
    }

    if (x >= lines[y].length() || x < 0) {
        return " ";
    }

    return lines[y][x];
}

function move_flat(Pos pos, string[] lines) returns Pos {
    Pos [posX, posY, dir] = pos;
    int nextX = posX;
    int nextY = posY;
    int nextDir = dir;

    match dir {
        RIGHT => {
            nextX += 1;
            if get_square(lines, nextX, nextY) == " " {
                if lines[nextY][0] !== " " {
                    nextX = 0;
                } else {
                    nextX = (lines[nextY].lastIndexOf(" ") ?: -2) + 1;
                }
            }
        }
        LEFT => {
            nextX -= 1;
            if get_square(lines, nextX, nextY) == " " {
                nextX = lines[nextY].length() - 1;
            }
        }
        DOWN => {
            nextY += 1;
            if get_square(lines, nextX, nextY) == " " {
                nextY = 0;
                foreach string line in lines {
                    if line[nextX] !== " " {
                        break;
                    }
                    nextY += 1;
                }
            }
        }
        UP => {
            nextY -= 1;
            if get_square(lines, nextX, nextY) == " " {
                nextY = lines.length();
                while get_square(lines, nextX, nextY) == " " {
                    nextY -= 1;
                }
            }
        }
        _ => {
            io:println(`Invalid direction ${dir}`);
            panic error("Invalid direction");
        }
    }

    return [nextX, nextY, nextDir];
}

function move_cube(Pos pos, string[] lines) returns Pos {
    Pos [posX, posY, dir] = pos;
    int nextY = posY;
    int nextX = posX;
    int nextDir = dir;
    int blockX = nextX / 50;
    int blockY = nextY / 50;

    match dir {
        RIGHT => {
            match [(posX + 1) % 50, blockX, blockY] {
                [0, 2, 0] => {
                    nextY = 149 - posY;
                    nextX = 99;
                    nextDir = LEFT;
                }
                [0, 1, 1] => {
                    nextY = 49;
                    nextX = posY - 50 + 100;
                    nextDir = UP;
                }
                [0, 1, 2] => {
                    nextY = 50 - (posY - 99);
                    nextX = 149;
                    nextDir = LEFT;
                }
                [0, 0, 3] => {
                    nextY = 149;
                    nextX = posY - 150 + 50;
                    nextDir = UP;
                }
                _ => { nextX += 1; }
            }
        }
        LEFT => {
            match [posX % 50, blockX, blockY] {
                [0, 1, 0] => {
                    nextY = 149 - posY;
                    nextX = 0;
                    nextDir = RIGHT;
                }
                [0, 1, 1] => {
                    nextY = 100;
                    nextX = posY - 50;
                    nextDir = DOWN;
                }
                [0, 0, 2] => {
                    nextY = (49 - (posY - 100));
                    nextX = 50;
                    nextDir = RIGHT;
                }
                [0, 0, 3] => {
                    nextY = 0;
                    nextX = posY - 150 + 50;
                    nextDir = DOWN;
                }
                _ => { nextX -= 1; }
            }
        }
        DOWN => {
            match [(posY + 1) % 50, blockX, blockY] {
                [0, 2, 0] => {
                    nextY = posX - 100 + 50;
                    nextX = 99;
                    nextDir = LEFT;
                }
                [0, 1, 2] => {
                    nextY = posX - 50 + 150;
                    nextX = 49;
                    nextDir = LEFT;
                }
                [0, 0, 3] => {
                    nextY = 0;
                    nextX = posX + 100;
                    nextDir = DOWN;
                }
                _ => { nextY += 1; }
            }
        }
        UP => {
            match [posY % 50, blockX, blockY] {
                [0, 1, 0] => {
                    nextY = posX - 50 + 150;
                    nextX = 0;
                    nextDir = RIGHT;
                }
                [0, 2, 0] => {
                    nextY = 199;
                    nextX = posX - 100;
                    nextDir = UP;
                }
                [0, 0, 2] => {
                    nextY = posX + 50;
                    nextX = 50;
                    nextDir = RIGHT;
                }
                _ => { nextY -= 1; }
            }
        }
        _ => {
            io:println(`Invalid direction ${dir}`);
            panic error("Invalid direction");
        }
    }

    return [nextX, nextY, nextDir];
}

public function main() returns error? {
    boolean part2 = os:getEnv("part") === "part2";
    string[] lines = check io:fileReadLines("./input.txt");
    string path = lines.pop() + "X";
    string _ = lines.pop();

    Move[] moves = regex:searchAll(path, "[0-9]+[A-Z]")
        .map(n => n.matched)
        .map(function(string n) returns Move {
            string dir = n.substring(n.length() - 1);
            int|error length = int:fromString(n.substring(0, n.length() - 1));
            if length is error {
                panic error("Failed to parse move length");
            }
            return {length, dir};
        });

    int posY = 0;
    int posX = lines[0].indexOf(".") ?: 0;
    int dir = RIGHT;

    foreach var move in moves {
        foreach int i in 0 ..< move.length {
            Pos [nextX, nextY, nextDir] = part2 ?
                move_cube([posX, posY, dir], lines) :
                move_flat([posX, posY, dir], lines);

            if get_square(lines, nextX, nextY) == "." {
                posY = nextY;
                posX = nextX;
                dir = nextDir;
            }
        }

        if move.dir != "X" {
            int rot = move.dir == "R" ? 1 : -1;
            dir = mod(dir + rot, 4);
        }
    }

    int score = 1000 * (posY + 1) + 4 * (posX + 1) + dir;
    io:println(score);
}
