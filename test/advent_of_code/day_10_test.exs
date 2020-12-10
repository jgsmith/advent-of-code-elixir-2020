defmodule AdventOfCode.Day10Test do
  use ExUnit.Case

  import AdventOfCode.Day10

  test "part1" do
    input =
      parse_file("""
      28
      33
      18
      42
      31
      14
      46
      20
      48
      47
      24
      23
      49
      45
      19
      38
      39
      11
      1
      32
      25
      35
      8
      17
      7
      9
      4
      2
      34
      10
      3
      """)

    result = part1(input)

    assert result == 22 * 10
  end

  test "part2" do
    input = [1, 4, 5, 6, 7, 10, 11, 12, 15, 16, 19]
    result = part2(input)
    assert result == 8

    input =
      parse_file("""
      28
      33
      18
      42
      31
      14
      46
      20
      48
      47
      24
      23
      49
      45
      19
      38
      39
      11
      1
      32
      25
      35
      8
      17
      7
      9
      4
      2
      34
      10
      3
      """)

    result = part2(input)

    assert result == 19208
  end
end
