defmodule AdventOfCode.Day03 do
  def part1(args) when is_tuple(args) do
    count_trees_on_slope(args, 3, 1)
  end

  def part1(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part1()
  end

  def part1(), do: part1("./data/day03.txt")

  def part2(args) when is_tuple(args) do
    [
      count_trees_on_slope(args, 1, 1),
      count_trees_on_slope(args, 3, 1),
      count_trees_on_slope(args, 5, 1),
      count_trees_on_slope(args, 7, 1),
      count_trees_on_slope(args, 1, 2)
    ]
    |> Enum.reduce(1, &(&1 * &2))
  end

  def part2(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part2()
  end

  def part2(), do: part2("./data/day03.txt")

  def read_from_file(filename) do
    filename
    |> File.read!()
    |> parse_file()
  end

  def parse_file(content) when is_binary(content) do
    terrain =
      content
      |> String.split(~r{\s*\n\s*})
      |> Enum.reject(&String.match?(&1, ~r/^\s*$/))
      |> Enum.map(&parse_line/1)
      |> List.to_tuple()

    {terrain, tuple_size(elem(terrain, 0)), tuple_size(terrain)}
  end

  def parse_line(line) do
    line
    |> String.graphemes()
    |> Enum.map(fn
      # tree
      "#" -> 1
      # not tree
      _ -> 0
    end)
    |> List.to_tuple()
  end

  def at({_, _, maxy}, _, y) when y >= maxy, do: 0

  def at({terrain, maxx, _maxy}, x, y) do
    x = Integer.mod(x, maxx)

    terrain
    |> elem(y)
    |> elem(x)
  end

  def count_trees_on_slope(map, deltax, deltay, x \\ 0, y \\ 0, acc \\ 0)

  def count_trees_on_slope({_, _, maxy}, _, _, _, y, acc) when y >= maxy, do: acc

  def count_trees_on_slope(map, deltax, deltay, x, y, acc) do
    count_trees_on_slope(map, deltax, deltay, x + deltax, y + deltay, acc + at(map, x, y))
  end
end
