defmodule AdventOfCode.Day18 do
  def part1(), do: part1("./data/day18.txt")

  def part1(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part1()
  end

  def part1(args) do
    args
    |> Enum.map(&execute_expression/1)
    |> Enum.sum()
  end

  def part2(), do: part2("./data/day18.txt")

  def part2(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part2()
  end

  def part2(args) do
    args
    |> Enum.map(&execute_expression2/1)
    |> Enum.sum()
  end

  def read_from_file(filename) do
    filename
    |> File.read!()
    |> parse_file()
  end

  def parse_file(content) do
    content
    |> String.split(~r{\s*\n\s*}, trim: true)
    |> Enum.map(&parse_expression/1)
  end

  def parse_expression(line, op_acc \\ [], lit_acc \\ [])
  def parse_expression("", op_acc, lit_acc), do: {Enum.reverse(op_acc), Enum.reverse(lit_acc)}

  def parse_expression(<<" ", rest::binary>>, op_acc, lit_acc),
    do: parse_expression(rest, op_acc, lit_acc)

  def parse_expression(<<"+", rest::binary>>, op_acc, lit_acc),
    do: parse_expression(rest, [:add | op_acc], lit_acc)

  def parse_expression(<<"*", rest::binary>>, op_acc, lit_acc),
    do: parse_expression(rest, [:mpy | op_acc], lit_acc)

  def parse_expression(<<"(", rest::binary>>, op_acc, lit_acc),
    do: parse_expression(rest, [:sub | op_acc], lit_acc)

  def parse_expression(<<")", rest::binary>>, op_acc, lit_acc),
    do: parse_expression(rest, [:bus | op_acc], lit_acc)

  def parse_expression(line, op_acc, lit_acc) do
    case Integer.parse(line) do
      {int, rest} ->
        parse_expression(rest, op_acc, [int | lit_acc])

      :error ->
        {:error, line}
    end
  end

  ### Evaluating expressions for Part 1
  def execute_expression({[], [lit]}), do: lit

  def execute_expression({[:sub | ops], lits}) do
    case execute_expression({ops, lits}) do
      {remaining_ops, new_lits} ->
        execute_expression({remaining_ops, new_lits})

      n when is_number(n) ->
        n
    end
  end

  def execute_expression({[:bus | ops], lits}), do: {ops, lits}

  def execute_expression({[op, :sub | ops], [a | lits]}) do
    case execute_expression({ops, lits}) do
      {remaining_ops, new_lits} ->
        execute_expression({[op | remaining_ops], [a | new_lits]})

      n when is_number(n) ->
        execute_expression({[op], [a, n]})
    end
  end

  def execute_expression({[:add | ops], [a, b | lits]}),
    do: execute_expression({ops, [a + b | lits]})

  def execute_expression({[:mpy | ops], [a, b | lits]}),
    do: execute_expression({ops, [a * b | lits]})

  ### Evaluating expressions for Part 2
  def execute_expression2(state, delayed_lits \\ [])
  def execute_expression2({[], [lit]}, []), do: lit

  def execute_expression2({[], [lit]}, delayed_lits) do
    execute_delayed_ops([lit | delayed_lits])
  end

  def execute_expression2({[:sub | ops], lits}, delayed_lits) do
    case execute_expression2({ops, lits}, []) do
      {remaining_ops, new_lits} ->
        execute_expression2({remaining_ops, new_lits}, delayed_lits)

      n when is_number(n) ->
        execute_expression2({[], [n]}, delayed_lits)
    end
  end

  def execute_expression2({[:bus | ops], [a | lits]}, delayed_lits) do
    {ops, [execute_delayed_ops([a | delayed_lits]) | lits]}
  end

  def execute_expression2({[op, :sub | ops], [a | lits]}, delayed_lits) do
    case execute_expression2({ops, lits}) do
      {remaining_ops, new_lits} ->
        execute_expression2({[op | remaining_ops], [a | new_lits]}, delayed_lits)

      n when is_number(n) ->
        execute_expression2({[op], [a, n]}, delayed_lits)
    end
  end

  def execute_expression2({[:add | ops], [a, b | lits]}, delayed_lits) do
    execute_expression2({ops, [a + b | lits]}, delayed_lits)
  end

  def execute_expression2({[:mpy | ops], [a | lits]}, delayed_lits) do
    execute_expression2({ops, lits}, [a | delayed_lits])
  end

  def execute_delayed_ops(terms), do: Enum.reduce(terms, fn x, y -> x * y end)
end
