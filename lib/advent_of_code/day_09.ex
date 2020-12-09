defmodule AdventOfCode.Day09 do
  def part1(), do: part1("./data/day09.txt")

  def part1(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part1()
  end

  def part1(args) when is_list(args) do
    {[result | _], _} = find_first_invalid(args, 25)
    result
  end

  def part2(), do: part2("./data/day09.txt")

  def part2(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part2()
  end

  def part2(args) do
    target = part1(args)
    find_weakness(args, target)
  end

  def read_from_file(filename) do
    filename
    |> File.read!()
    |> parse_file()
  end

  def parse_file(content) do
    content
    |> String.split(~r{\s*\n\s*}, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def init_window(list, count) do
    {first_ones, rest} = Enum.split(list, count)
    {rest, {count, build_window(first_ones)}}
  end

  def build_window(list, acc \\ [])
  def build_window([], acc), do: Enum.reverse(acc)

  def build_window([n | rest], acc) do
    stack = for m <- rest, do: n + m
    build_window(rest, [{n, stack} | acc])
  end

  def slide_window({[n | list], {pos, window}}) do
    # drop one off the window and add one from the list
    new_window =
      window
      |> Enum.drop(1)
      |> Enum.map(fn {m, stack} -> {m, [n + m | stack]} end)

    {list, {pos + 1, new_window ++ [{n, []}]}}
  end

  def valid_head?({[n | _], {_, window}}) do
    window
    |> Enum.any?(fn {_, stack} -> n in stack end)
  end

  def find_first_invalid(list, count) when is_integer(count) do
    list
    |> init_window(count)
    |> find_first_invalid()
  end

  def find_first_invalid({[], _}), do: nil

  def find_first_invalid(state) do
    if valid_head?(state) do
      find_first_invalid(slide_window(state))
    else
      state
    end
  end

  def find_weakness(list, target) do
    abs_max = Enum.max(list)
    abs_min = Enum.min(list)

    find_weakness(list, target, abs_max, abs_min)
  end

  def find_weakness([_ | rest] = list, target, min, max) do
    case find_contiguous_sum(list, target, min, max) do
      nil -> find_weakness(rest, target, min, max)
      n -> n
    end
  end

  def find_contiguous_sum([n | rest], target, min_n, max_n) do
    cond do
      n > target -> nil
      n < target -> find_contiguous_sum(rest, target - n, min(min_n, n), max(max_n, n))
      n == target -> min(min_n, n) + max(max_n, n)
    end
  end
end
