defmodule AdventOfCode.Day15Test do
  use ExUnit.Case

  import AdventOfCode.Day15

  test "part1" do
    assert part1([1, 3, 2]) == 1
    assert part1([2, 1, 3]) == 10
  end
end
