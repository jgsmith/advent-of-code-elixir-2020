defmodule AdventOfCode.Day01 do
  @type expenses :: [integer]
  @type expense_set :: [integer]
  @type expense_sets :: [expense_set]
  @type context :: {expenses, integer}

  def part1(args) when is_list(args) do
    IO.inspect(find_product(2, new_context(args, 2020)))
  end

  def part1(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part1()
  end

  def part1(), do: part1("./data/day01.txt")

  def part2(args) when is_list(args) do
    IO.inspect(find_product(3, new_context(args, 2020)))
  end

  def part2(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part2()
  end

  def part2(), do: part2("./data/day01.txt")

  def read_from_file(filename) do
    filename
    |> File.read!()
    |> String.split(~r{\s*\n\s*})
    |> Enum.reject(fn s -> Regex.match?(~r/^\s*$/, s) end)
    |> Enum.map(&String.to_integer/1)
  end

  @spec new_context(expenses, integer) :: context
  def new_context(expenses, target) do
    {Enum.sort(expenses), target}
  end

  @spec find_product(integer, context) :: integer
  def find_product(count, context) do
    list = find_sum(count, context)
    Enum.reduce(list, 1, fn x, y -> x * y end)
  end

  @spec find_sum(integer, context) :: [integer]
  def find_sum(count, context) do
    [[]]
    |> build_possible_terms(count, context)
    |> Enum.find(&sum_matching?(&1, context))
  end

  @spec sum_matching?(expense_set, context) :: bool
  def sum_matching?(list, {_, target}) do
    if Enum.any?(list, &is_nil/1) do
      false
    else
      Enum.sum(list) == target
    end
  end

  @spec build_possible_terms(expense_sets, integer, context) :: [[integer]]
  def build_possible_terms(terms, 0, _), do: terms

  def build_possible_terms(terms, count, context) do
    terms
    |> Enum.flat_map(&collect_next_sets(&1, context))
    |> build_possible_terms(count - 1, context)
  end

  @spec collect_next_sets(expense_set, context) :: [[integer]]
  def collect_next_sets(term, {sorted_expenses, target}) do
    used = Enum.sum(term)
    available = target - used

    sorted_expenses
    |> Enum.take_while(&(&1 <= available))
    |> Enum.map(&[&1 | term])
  end
end
