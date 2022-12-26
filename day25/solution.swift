import Foundation

let snafu_digits: [Character] = ["=", "-", "0", "1", "2"]

func snafu2dec(snafu: String) -> Int {
  var dec = 0

  for (index, char) in snafu.reversed().enumerated() {
    let value = snafu_digits.firstIndex(of: char)! - 2
    let multiplier = NSDecimalNumber(decimal: pow(5, index)).intValue
    dec += value * multiplier
  }

  return dec
}

func dec2snafu(dec: Int) -> String {
  var remaining = dec
  var out = ""

  while remaining > 0 {
    switch remaining % 5 {
    case 0:
      out += "0"
      remaining /= 5
    case 1:
      out += "1"
      remaining /= 5
    case 2:
      out += "2"
      remaining /= 5
    case 3:
      out += "="
      remaining = (remaining + 2) / 5
    case 4:
      out += "-"
      remaining = (remaining + 1) / 5
    default:
      fatalError()
    }
  }

  return String(out.reversed())
}

let content = try String(contentsOfFile: "./input.txt")
let lines =
  content
  .trimmingCharacters(in: .whitespacesAndNewlines)
  .components(separatedBy: .newlines)

let result = dec2snafu(dec: lines.map { snafu2dec(snafu: $0) }.reduce(0, +))
print(result)
