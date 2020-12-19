defmodule AdventOfCode.Day19Test do
  use ExUnit.Case

  import AdventOfCode.Day19

  @tag :skip
  test "part1" do
    input =
      parse_file("""
      0: 4 1 5
      1: 2 3 | 3 2
      2: 4 4 | 5 5
      3: 4 5 | 5 4
      4: "a"
      5: "b"

      ababbb
      bababa
      abbbab
      aaabbb
      aaaabbb
      """)

    result = part1(input)

    assert result == 2
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
