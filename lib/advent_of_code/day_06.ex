defmodule AdventOfCode.Day06 do
  def part1(args) when is_list(args) do
    args
    |> Enum.map(&number_answered_by_any_in_group/1)
    |> Enum.sum()
  end

  def part1(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part1()
  end

  def part1(), do: part1("./data/day06.txt")

  def part2(args) when is_list(args) do
    args
    |> Enum.map(&number_answered_by_all_in_group/1)
    |> Enum.sum()
  end

  def part2(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part2()
  end

  def part2(), do: part2("./data/day06.txt")

  def read_from_file(filename) do
    filename
    |> File.read!()
    |> parse_file()
  end

  def parse_file(content) when is_binary(content) do
    content
    |> String.split(~r{\s*\n\s*\n\s*})
    |> Enum.reject(&String.match?(&1, ~r/^\s*$/))
    |> Enum.map(&group/1)
  end

  def group(chunk) do
    chunk
    |> String.split(~r{\s*\n\s*})
    |> Enum.reject(&String.match?(&1, ~r/^\s*$/))
    |> Enum.map(&person/1)
  end

  def person(line) do
    line
    |> String.graphemes()
    |> MapSet.new()
  end

  def number_answered_by_any_in_group(people) do
    people
    |> Enum.reduce(MapSet.new(), &MapSet.union/2)
    |> MapSet.size()
  end

  def number_answered_by_all_in_group([first | people]) do
    people
    |> Enum.reduce(first, &MapSet.intersection/2)
    |> MapSet.size()
  end
end
