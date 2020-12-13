defmodule AdventOfCode.Day13Test do
  use ExUnit.Case

  import AdventOfCode.Day13

  test "part1" do
    input =
      parse_file("""
      939
      7,13,x,x,59,x,31,19
      """)

    result = part1(input)

    assert result == 295
  end

  test "part2" do
    input =
      parse_file("""
      939
      7,13,x,x,59,x,31,19
      """)

    result = part2(input)

    assert result == 1_068_781

    input =
      parse_file("""
      123
      17,x,13,19
      """)

    result = part2(input)

    assert result == 3417

    input =
      parse_file("""
      123
      1789,37,47,1889
      """)

    result = part2(input)

    assert result == 1_202_161_486
  end
end
