defmodule AdventOfCode.Day17Test do
  use ExUnit.Case

  import AdventOfCode.Day17

  test "part1" do
    input =
      parse_file("""
      .#.
      ..#
      ###
      """)

    result = part1(input)

    assert result == 112
  end

  test "part2" do
    input =
      parse_file("""
      .#.
      ..#
      ###
      """)

    result = part2(input)

    assert result == 848
  end
end
