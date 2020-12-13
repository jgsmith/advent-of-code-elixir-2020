defmodule AdventOfCode.Day13 do
  def part1(), do: part1("./data/day13.txt")

  def part1(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part1()
  end

  def part1(args) do
    {wait_time, bus} = find_earliest_bus(args)
    wait_time * bus
  end

  def part2(), do: part2("./data/day13.txt")

  def part2(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part2()
  end

  def part2(args) do
    find_earliest_sequential_bus_departures(args)
  end

  def read_from_file(filename) do
    filename
    |> File.read!()
    |> parse_file()
  end

  def parse_file(content) do
    [line1, line2 | _] = String.split(content, ~r{\s*\n\s*}, trim: true)
    {earliest_time, ""} = Integer.parse(line1)

    busses =
      line2
      |> String.split(",")
      |> Enum.map(fn
        "x" -> nil
        s -> String.to_integer(s)
      end)

    {earliest_time, busses}
  end

  def find_earliest_bus({earliest_time, busses}) do
    busses
    |> Enum.reject(&is_nil/1)
    |> Enum.map(fn bus ->
      {bus - Integer.mod(earliest_time, bus), bus}
    end)
    |> Enum.sort()
    |> List.first()
  end

  def find_earliest_sequential_bus_departures({_, busses}) do
    busses
    |> Enum.with_index()
    |> Enum.reject(fn {n, _} -> is_nil(n) end)
    |> Enum.map(fn {r, a} -> {r, rem(r - a, r)} end)
    |> Enum.sort()
    |> Enum.unzip()
    |> crt
  end

  # Generalized chinese remainder theorem based on
  # http://www.oocities.org/hjsmithh/Numbers/ChineseRT.pdf
  def crt({[r, s], [a, b]}) do
    {_, n} = crt_step(r, s, a, b)
    n
  end

  def crt({[r, s | rest_moduli], [a, b | rest_remainders]}) do
    case crt_step(r, s, a, b) do
      nil ->
        nil

      {m, n} ->
        crt({[m | rest_moduli], [n | rest_remainders]})
    end
  end

  def egcd(_, 0), do: {1, 0}

  def egcd(a, b) do
    {s, t} = egcd(b, Integer.mod(a, b))
    {t, s - div(a, b) * t}
  end

  def crt_step(r, s, a, b) do
    {u, v} = egcd(r, s)
    d = r * u + s * v

    if rem(b - a, d) == 0 do
      p = div(r, d)
      q = a + u * p * (b - a)
      m = p * s
      n = Integer.mod(q, m)
      {m, n}
    end
  end
end
