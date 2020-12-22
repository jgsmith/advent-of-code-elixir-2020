defmodule AdventOfCode.Day22Test do
  use ExUnit.Case

  import AdventOfCode.Day22

  test "part1" do
    input =
      parse_file("""
      Player 1:
      9
      2
      6
      3
      1

      Player 2:
      5
      8
      4
      7
      10
      """)

    result = part1(input)

    assert result == 306
  end

  test "part2 infinite loop" do
    input =
      parse_file("""
      Player 1:
      43
      19

      Player 2:
      2
      29
      14
      """)

    result = part2(input)

    assert result == 105
  end

  test "part2" do
    input =
      parse_file("""
      Player 1:
      9
      2
      6
      3
      1

      Player 2:
      5
      8
      4
      7
      10
      """)

    result = part2(input)

    assert result == 291
  end
end
