defmodule AdventOfCode.Day11 do
  def part1(), do: part1("./data/day11.txt")

  def part1(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part1()
  end

  def part1(map) when is_tuple(map) do
    map
    |> run_generations()
    |> count_occupied_seats()
  end

  def part2(), do: part2("./data/day11.txt")

  def part2(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part2()
  end

  def part2(map) when is_tuple(map) do
    map
    |> run_generations_los()
    |> count_occupied_seats()
  end

  def read_from_file(filename) do
    filename
    |> File.read!()
    |> parse_file()
  end

  def parse_file(content) do
    lines =
      content
      |> String.split(~r{\s*\n\s*}, trim: true)

    map =
      lines
      |> Enum.with_index()
      |> Enum.map(fn {line, row} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Map.new(fn {char, col} ->
          {{row, col}, char}
        end)
      end)
      |> Enum.reduce(Map.new(), &Map.merge/2)

    {map, Enum.count(lines), String.length(Enum.at(lines, 0))}
  end

  def at({map, _, _}, row, col) do
    Map.get(map, {row, col}, ".")
  end

  def in_los({_, rows, cols}, row, col, _, _)
      when row < 0 or col < 0 or row >= rows or col >= cols,
      do: "."

  def in_los(map, row, col, deltar, deltac) do
    case at(map, row + deltar, col + deltac) do
      "." -> in_los(map, row + deltar, col + deltac, deltar, deltac)
      c -> c
    end
  end

  def line_of_sight(map, row, col) do
    [
      in_los(map, row, col, -1, 0),
      in_los(map, row, col, -1, +1),
      in_los(map, row, col, 0, +1),
      in_los(map, row, col, +1, +1),
      in_los(map, row, col, +1, 0),
      in_los(map, row, col, +1, -1),
      in_los(map, row, col, 0, -1),
      in_los(map, row, col, -1, -1)
    ]
  end

  def around(map, row, col) do
    [
      at(map, row - 1, col),
      at(map, row - 1, col + 1),
      at(map, row, col + 1),
      at(map, row + 1, col + 1),
      at(map, row + 1, col),
      at(map, row + 1, col - 1),
      at(map, row, col - 1),
      at(map, row - 1, col - 1)
    ]
  end

  def seen(list), do: Enum.count(list, &(&1 == "#"))

  def action_at(map, row, col) do
    case at(map, row, col) do
      "L" -> if seen(around(map, row, col)) > 0, do: "L", else: "#"
      "#" -> if seen(around(map, row, col)) >= 4, do: "L", else: "#"
      c -> c
    end
  end

  def action_at_los(map, row, col) do
    case at(map, row, col) do
      "L" -> if seen(line_of_sight(map, row, col)) > 0, do: "L", else: "#"
      "#" -> if seen(line_of_sight(map, row, col)) >= 5, do: "L", else: "#"
      c -> c
    end
  end

  def next_generation({_, rows, cols} = map) do
    new_map =
      Map.new(
        for row <- 0..(rows - 1), col <- 0..(cols - 1) do
          {{row, col}, action_at(map, row, col)}
        end
      )

    {new_map, rows, cols}
  end

  def run_generations(map) do
    new_map = next_generation(map)
    if new_map == map, do: new_map, else: run_generations(new_map)
  end

  def next_generation_los({_, rows, cols} = map) do
    new_map =
      Map.new(
        for row <- 0..(rows - 1), col <- 0..(cols - 1) do
          {{row, col}, action_at_los(map, row, col)}
        end
      )

    {new_map, rows, cols}
  end

  def run_generations_los(map) do
    new_map = next_generation_los(map)
    if new_map == map, do: new_map, else: run_generations_los(new_map)
  end

  def count_occupied_seats({map, _, _} = mmap) do
    map
    |> Map.values()
    |> Enum.count(&(&1 == "#"))
  end
end
