defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  test "new_context" do
    input = [1721, 979, 366, 299, 675, 1456]

    assert new_context(input, 2020) == {Enum.sort(input), 2020}
  end

  test "build_possible_terms" do
    input = [1721, 979, 366, 299, 675, 1456]
    context = new_context(input, 2020)

    result = build_possible_terms([[299]], 1, context)
    assert result == [[299, 299], [366, 299], [675, 299], [979, 299], [1456, 299], [1721, 299]]
  end

  test "find_sum" do
    context = new_context([1721, 979, 366, 299, 675, 1456], 2020)

    result = find_sum(2, context)
    assert result == [1721, 299]

    result = find_sum(3, context)
    assert result == [979, 675, 366]
  end

  test "find_product" do
    context = new_context([1721, 979, 366, 299, 675, 1456], 2020)

    result = find_product(2, context)
    assert result == 514_579

    result = find_product(3, context)
    assert result == 241_861_950
  end
end
