defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  test "good_password_count" do
    input =
      parse_file("""
      1-3 a: abcde
      1-3 b: cdefg
      2-9 c: ccccccccc
      """)

    result = good_password_count(input)

    assert result == 2
  end

  test "new_good_password_count" do
    input =
      parse_file("""
      1-3 a: abcde
      1-3 b: cdefg
      2-9 c: ccccccccc
      """)

    result = new_good_password_count(input)

    assert result == 1
  end
end
