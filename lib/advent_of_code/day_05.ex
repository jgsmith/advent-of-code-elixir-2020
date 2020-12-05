defmodule AdventOfCode.Day05 do
  def part1(args) when is_list(args) do
    args
    |> List.last()
  end

  def part1(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part1()
  end

  def part1(), do: part1("./data/day05.txt")

  def part2(args) when is_list(args) do
    # find a missing spot in the middle of the list
    (args
     |> Enum.drop(1)
     |> Enum.zip(args)
     |> Enum.find(fn {id_plus_1, id_minus_1} -> id_plus_1 == id_minus_1 + 2 end)
     |> elem(0)) - 1
  end

  def part2(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part2()
  end

  def part2(), do: part2("./data/day05.txt")

  def read_from_file(filename) do
    filename
    |> File.read!()
    |> parse_file()
  end

  def parse_file(content) when is_binary(content) do
    content
    |> String.split(~r{\s*\n\s*})
    |> Enum.reject(&String.match?(&1, ~r/^\s*$/))
    |> Enum.map(&seat/1)
    |> Enum.sort()
  end

  def seat(boarding_pass, acc \\ {0, 0})

  def seat("", {r, s}), do: r * 8 + s
  def seat(<<"F", rest::binary>>, {r, s}), do: seat(rest, {r * 2, s})
  def seat(<<"B", rest::binary>>, {r, s}), do: seat(rest, {r * 2 + 1, s})
  def seat(<<"R", rest::binary>>, {r, s}), do: seat(rest, {r, s * 2 + 1})
  def seat(<<"L", rest::binary>>, {r, s}), do: seat(rest, {r, s * 2})
end
