defmodule AdventOfCode.Day18Test do
  use ExUnit.Case

  import AdventOfCode.Day18

  @skip true
  test "parse_expression" do
    assert parse_expression("1 + 2 * 3") == {[:add, :mpy], [1, 2, 3]}

    assert parse_expression("1 + (2 * 3) * (4 + 5)") ==
             {[:add, :sub, :mpy, :bus, :mpy, :sub, :add, :bus], [1, 2, 3, 4, 5]}

    assert parse_expression("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") ==
             {[
                :sub,
                :sub,
                :add,
                :mpy,
                :bus,
                :mpy,
                :sub,
                :add,
                :mpy,
                :add,
                :bus,
                :add,
                :bus,
                :add,
                :add,
                :mpy
              ], [2, 4, 9, 6, 9, 8, 6, 6, 2, 4, 2]}
  end

  test "execute_expression" do
    assert execute_expression({[:add, :mpy], [1, 2, 3]}) == 9

    assert execute_expression({[:add, :sub, :mpy, :bus, :mpy, :sub, :add, :bus], [1, 2, 3, 4, 5]}) ==
             63

    assert execute_expression(
             {[
                :sub,
                :sub,
                :add,
                :mpy,
                :bus,
                :mpy,
                :sub,
                :add,
                :mpy,
                :add,
                :bus,
                :add,
                :bus,
                :add,
                :add,
                :mpy
              ], [2, 4, 9, 6, 9, 8, 6, 6, 2, 4, 2]}
           ) == 13632
  end

  test "execute_expression2" do
    assert execute_expression2({[:add], [1, 2]}) == 3
    assert execute_expression2({[:mpy], [1, 2]}) == 2
    assert execute_expression2({[:add, :mpy], [1, 2, 3]}) == 9
    assert execute_expression2({[:mpy, :add, :add, :mpy], [2, 3, 4, 5, 6]}) == 144

    assert "1 + 2 * 3 + 4 * 5 + 6" |> parse_expression |> execute_expression2 == 231

    assert "1 + (2 * 3) + (4 * (5 + 6))" |> parse_expression |> execute_expression2 == 51
    assert "2 * 3 + (4 * 5)" |> parse_expression |> execute_expression2 == 46
    assert "5 + (8 * 3 + 9 + 3 * 4 * 3)" |> parse_expression |> execute_expression2 == 1445

    assert "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))" |> parse_expression |> execute_expression2 ==
             669_060

    assert "((1 + 2) + 3)" |> parse_expression |> execute_expression2 == 6

    assert "((1 * 2) + 3)" |> parse_expression |> execute_expression2 == 5

    assert "(54 * 210 + 6) + 6 * 2"
           |> parse_expression
           |> execute_expression2 == 23340
  end

  test "expressions" do
    assert "2 * 3 + (4 * 5)" |> parse_expression |> execute_expression == 26
    assert "5 + (8 * 3 + 9 + 3 * 4 * 3)" |> parse_expression |> execute_expression == 437

    assert "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))" |> parse_expression |> execute_expression ==
             12240

    assert "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"
           |> parse_expression
           |> execute_expression == 13632
  end

  test "part1" do
    input =
      parse_file("""
      2 * 3 + (4 * 5)
      5 + (8 * 3 + 9 + 3 * 4 * 3)
      5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))
      ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2
      """)

    result = part1(input)

    assert result == 26 + 437 + 12240 + 13632
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
