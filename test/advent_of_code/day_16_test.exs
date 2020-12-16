defmodule AdventOfCode.Day16Test do
  use ExUnit.Case

  import AdventOfCode.Day16

  test "part1" do
    input =
      parse_file("""
      class: 1-3 or 5-7
      row: 6-11 or 33-44
      seat: 13-40 or 45-50

      your ticket:
      7,1,14

      nearby tickets:
      7,3,47
      40,4,50
      55,2,20
      38,6,12
      """)

    result = part1(input)

    assert result == 71
  end

  test "tickets_to_columns" do
    transpose = tickets_to_columns([[1, 2], [3, 4], [5, 6]])
    assert transpose == [[1, 3, 5], [2, 4, 6]]
  end

  test "part2" do
    input =
      parse_file("""
      departure class: 1-3 or 5-7
      row: 6-11 or 33-44
      departure seat: 13-40 or 45-50

      your ticket:
      7,1,14

      nearby tickets:
      7,3,47
      40,4,50
      55,2,20
      38,6,12
      """)

    result = part2(input)

    assert result == 14
  end
end
