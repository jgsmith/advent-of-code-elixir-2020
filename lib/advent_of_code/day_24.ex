defmodule AdventOfCode.Day24 do
  def part1(), do: part1("./data/day24.txt")

  def part1(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part1()
  end

  def part1(args) do
    args
    |> color_tiles()
    |> count_colored_tiles()
  end

  def part2(), do: part2("./data/day24.txt")

  def part2(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part2()
  end

  def part2(args) do
    args
    |> color_tiles()
    |> game_rounds(100)
    |> count_colored_tiles()
  end

  def read_from_file(filename) do
    filename
    |> File.read!()
    |> parse_file()
  end

  def parse_file(content) do
    content
    |> String.split(~r{\s*\n\s*}, trim: true)
  end

  def color_tiles(directions) do
    directions
    |> Enum.map(&walk/1)
    |> Enum.reduce(MapSet.new(), fn coord, map ->
      if MapSet.member?(map, coord) do
        MapSet.delete(map, coord)
      else
        MapSet.put(map, coord)
      end
    end)
  end

  def count_colored_tiles(map) do
    MapSet.size(map)
  end

  def walk(directions, coord \\ {0, 0})
  def walk(<<>>, coord), do: coord
  def walk(<<"e", rest::binary>>, {q, r}), do: walk(rest, {q + 1, r})
  def walk(<<"w", rest::binary>>, {q, r}), do: walk(rest, {q - 1, r})
  def walk(<<"nw", rest::binary>>, {q, r}), do: walk(rest, {q, r + 1})
  def walk(<<"se", rest::binary>>, {q, r}), do: walk(rest, {q, r - 1})
  def walk(<<"ne", rest::binary>>, {q, r}), do: walk(rest, {q + 1, r + 1})
  def walk(<<"sw", rest::binary>>, {q, r}), do: walk(rest, {q - 1, r - 1})

  def expand_coord({q, r}) do
    [
      {q + 1, r},
      {q - 1, r},
      {q, r + 1},
      {q, r - 1},
      {q + 1, r + 1},
      {q - 1, r - 1}
    ]
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
      n == 1 or n == 2
    else
      n == 2
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
