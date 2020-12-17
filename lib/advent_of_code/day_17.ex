defmodule AdventOfCode.Day17 do
  def part1(), do: part1("./data/day17.txt")

  def part1(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part1()
  end

  def part1(map) do
    map
    |> game_rounds(6)
    |> MapSet.size()
  end

  def part2(), do: part2("./data/day17.txt")

  def part2(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part2()
  end

  def part2(map) do
    map
    |> extend_to_4d()
    |> game_rounds(6)
    |> MapSet.size()
  end

  def read_from_file(filename) do
    filename
    |> File.read!()
    |> parse_file()
  end

  def parse_file(content) do
    content
    |> String.split(~r{\s*\n\s*}, trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(&line_to_coords/1)
    |> MapSet.new()
  end

  def line_to_coords({line, y}) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.filter(fn
      {"#", _} -> true
      _ -> false
    end)
    |> Enum.map(fn {_, x} -> {x, y, 0} end)
  end

  def extend_to_4d(list_or_mapset, w \\ 0)

  def extend_to_4d(list, w) when is_list(list) do
    list
    |> Enum.map(fn {x, y, z} -> {x, y, z, w} end)
  end

  def extend_to_4d(map, w) do
    map
    |> MapSet.to_list()
    |> MapSet.new(fn {x, y, z} -> {x, y, z, w} end)
  end

  def expand_coord({x, y, z}) do
    [
      {x + 1, y, z},
      {x + 1, y, z + 1},
      {x + 1, y, z - 1},
      {x + 1, y + 1, z},
      {x + 1, y + 1, z + 1},
      {x + 1, y + 1, z - 1},
      {x + 1, y - 1, z},
      {x + 1, y - 1, z + 1},
      {x + 1, y - 1, z - 1},
      {x, y, z + 1},
      {x, y, z - 1},
      {x, y + 1, z},
      {x, y + 1, z + 1},
      {x, y + 1, z - 1},
      {x, y - 1, z},
      {x, y - 1, z + 1},
      {x, y - 1, z - 1},
      {x - 1, y, z},
      {x - 1, y, z + 1},
      {x - 1, y, z - 1},
      {x - 1, y + 1, z},
      {x - 1, y + 1, z + 1},
      {x - 1, y + 1, z - 1},
      {x - 1, y - 1, z},
      {x - 1, y - 1, z + 1},
      {x - 1, y - 1, z - 1}
    ]
  end

  def expand_coord({x, y, z, w}) do
    slice = expand_coord({x, y, z})

    [
      extend_to_4d(slice, w),
      extend_to_4d(slice, w + 1),
      extend_to_4d(slice, w - 1)
    ]
    |> Enum.reduce([{x, y, z, w + 1}, {x, y, z, w - 1}], &Enum.concat/2)
  end

  def expand_coords(coords) do
    coords
    |> Enum.flat_map(&expand_coord/1)
    |> Enum.uniq()
  end

  def coord_in_next_round?(coord, map) do
    n =
      coord
      |> expand_coord
      |> Enum.count(&MapSet.member?(map, &1))

    if MapSet.member?(map, coord) do
      n == 2 or n == 3
    else
      n == 3
    end
  end

  def select_coords_in_next_round(coords, map) do
    coords
    |> Enum.filter(&coord_in_next_round?(&1, map))
  end

  def game_round(map) do
    map
    |> MapSet.to_list()
    |> expand_coords
    |> select_coords_in_next_round(map)
    |> MapSet.new()
  end

  def game_rounds(map, 0), do: map

  def game_rounds(map, count) do
    map
    |> game_round
    |> game_rounds(count - 1)
  end
end
