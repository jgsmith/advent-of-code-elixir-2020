defmodule AdventOfCode.Day12 do
  def part1(), do: part1("./data/day12.txt")

  def part1(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part1()
  end

  def part1(args) do
    %{x: x, y: y} = drive(new_ship(), args)
    abs(x) + abs(y)
  end

  def part2(), do: part2("./data/day12.txt")

  def part2(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part2()
  end

  def part2(args) do
    %{x: x, y: y} = drive_with_waypoint(new_ship(), args)
    abs(x) + abs(y)
  end

  def read_from_file(filename) do
    filename
    |> File.read!()
    |> parse_file()
  end

  def parse_file(content) do
    content
    |> String.split(~r{\s*\n\s*}, trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(<<instruction::binary-1, rest::binary>>) do
    {n, ""} = Integer.parse(rest)
    {String.to_atom(String.downcase(instruction)), n}
  end

  # ship starts facing east (0 degree heading)
  # waypoint starts 10 units east and 1 unit north
  def new_ship(), do: %{x: 0, y: 0, wx: 10, wy: 1, heading: 0}

  ### Part 1

  def drive(ship, []), do: ship

  def drive(ship, [instruction | rest]) do
    ship
    |> step(instruction)
    |> drive(rest)
  end

  def step(ship, {:n, n}), do: move(ship, 270, n)
  def step(ship, {:s, n}), do: move(ship, 90, n)
  def step(ship, {:e, n}), do: move(ship, 0, n)
  def step(ship, {:w, n}), do: move(ship, 180, n)
  def step(%{heading: heading} = ship, {:f, n}), do: move(ship, heading, n)
  def step(ship, {:l, n}), do: turn(ship, -n)
  def step(ship, {:r, n}), do: turn(ship, n)

  def move(%{x: x, y: y} = ship, heading, distance) do
    case normalized_degrees(heading) do
      0 -> %{ship | x: x + distance}
      180 -> %{ship | x: x - distance}
      90 -> %{ship | y: y - distance}
      270 -> %{ship | y: y + distance}
    end
  end

  def turn(%{heading: heading} = ship, degrees) do
    %{ship | heading: normalized_degrees(heading + degrees)}
  end

  def normalized_degrees(degrees) when degrees < 0, do: normalized_degrees(degrees + 360)
  def normalized_degrees(degrees) when degrees >= 360, do: normalized_degrees(degrees - 360)
  def normalized_degrees(degrees), do: degrees

  ### Part 2

  def drive_with_waypoint(ship, []), do: ship

  def drive_with_waypoint(ship, [instruction | rest]) do
    ship
    |> step_with_waypoint(instruction)
    |> drive_with_waypoint(rest)
  end

  def step_with_waypoint(ship, {:n, n}), do: move_waypoint(ship, 270, n)
  def step_with_waypoint(ship, {:s, n}), do: move_waypoint(ship, 90, n)
  def step_with_waypoint(ship, {:e, n}), do: move_waypoint(ship, 0, n)
  def step_with_waypoint(ship, {:w, n}), do: move_waypoint(ship, 180, n)
  def step_with_waypoint(ship, {:f, n}), do: move_ship(ship, n)
  def step_with_waypoint(ship, {:l, n}), do: turn_waypoint(ship, -n)
  def step_with_waypoint(ship, {:r, n}), do: turn_waypoint(ship, n)

  def move_waypoint(%{wx: wx, wy: wy} = ship, heading, distance) do
    case normalized_degrees(heading) do
      0 -> %{ship | wx: wx + distance}
      180 -> %{ship | wx: wx - distance}
      90 -> %{ship | wy: wy - distance}
      270 -> %{ship | wy: wy + distance}
    end
  end

  def move_ship(%{wx: wx, wy: wy, x: x, y: y} = ship, multiplier) do
    %{ship | x: x + wx * multiplier, y: y + wy * multiplier}
  end

  def turn_waypoint(%{wx: wx, wy: wy} = ship, heading) do
    case normalized_degrees(heading) do
      0 -> ship
      180 -> %{ship | wx: -wx, wy: -wy}
      90 -> %{ship | wx: wy, wy: -wx}
      270 -> %{ship | wx: -wy, wy: wx}
    end
  end
end
