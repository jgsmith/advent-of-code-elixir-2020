defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Day05

  test "part1" do
    input =
      parse_file("""
      BFFFBBFRRR
      FFFBBBFRRR
      BBFFBBFRLL
      """)

    result = part1(input)

    assert result == 820
  end
end
