defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  test "part1" do
    input =
      parse_file("""
      F10
      N3
      F7
      R90
      F11
      """)

    result = part1(input)

    assert result == 25
  end

  test "part2" do
    input =
      parse_file("""
      F10
      N3
      F7
      R90
      F11
      """)

    result = part2(input)

    assert result == 286
  end
end
