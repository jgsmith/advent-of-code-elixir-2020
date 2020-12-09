defmodule AdventOfCode.Day09Test do
  use ExUnit.Case

  import AdventOfCode.Day09

  test "find_first_invalid" do
    input =
      parse_file("""
      35
      20
      15
      25
      47
      40
      62
      55
      65
      95
      102
      117
      150
      182
      127
      219
      299
      277
      309
      576
      """)

    {[result | _], _} = find_first_invalid(input, 5)

    assert result == 127
  end

  test "find_weakness" do
    input =
      parse_file("""
      35
      20
      15
      25
      47
      40
      62
      55
      65
      95
      102
      117
      150
      182
      127
      219
      299
      277
      309
      576
      """)

    result = find_weakness(input, 127)

    assert result == 62
  end
end
