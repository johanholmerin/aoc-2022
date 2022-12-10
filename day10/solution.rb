$cycle = 0
$reg = 1
$sum = 0
$display = Array.new(6) { '.' * 40 }

def check
  if ENV['part'] == 'part2'
    row = ($cycle - 1) / 40
    col = ($cycle - 1) % 40
    match = col == $reg || col == $reg - 1 || col == $reg + 1
    $display[row][col] = '#' if match
  elsif ($cycle + 20) % 40 == 0
    $sum += $reg * $cycle
  end
end

File.readlines('./input.txt', chomp: true).each do |line|
  $cycle += 1
  check
  next unless line != 'noop'

  $cycle += 1
  check
  $reg += line.match(/(-?[0-9]+)/)[0].to_i
end

puts ENV['part'] == 'part2' ? $display : $sum
