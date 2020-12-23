defmodule AdventOfCode.Day23Test do
  use ExUnit.Case

  import AdventOfCode.Day23

  test "part1" do
    input = "389125467"
    result = part1(input)

    assert result == "67384529"
  end

  test "rounds" do
    input = circle([3, 8, 9, 1, 2, 5, 4, 6, 7])

    results = [
      "25467389",
      "54673289",
      "32546789",
      "34672589",
      "32584679",
      "36792584",
      "93672584"
    ]

    for {expected_result, i} <- Enum.with_index(results) do
      result =
        input
        |> rounds(i)
        |> to_output

      assert {i, result} == {i, expected_result}
    end
  end

  test "part2" do
    input = "389125467"
    result = part2(input)

    assert result == 149_245_887_792
  end
end
