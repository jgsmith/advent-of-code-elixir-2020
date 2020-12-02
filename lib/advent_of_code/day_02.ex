defmodule AdventOfCode.Day02 do
  def part1(args) when is_list(args) do
    good_password_count(args)
  end

  def part1(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part1()
  end

  def part1(), do: part1("./data/day02.txt")

  def part2(args) when is_list(args) do
    new_good_password_count(args)
  end

  def part2(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part2()
  end

  def part2(), do: part2("./data/day02.txt")

  def read_from_file(filename) do
    filename
    |> File.read!()
    |> parse_file()
  end

  def parse_file(content) when is_binary(content) do
    content
    |> String.split(~r{\s*\n\s*})
    |> Enum.reject(fn s -> Regex.match?(~r/^\s*$/, s) end)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    # line:
    # \d+-\d+ \S: \S+
    with [_, minb, maxb, char, password] <- Regex.run(~r{(\d+)-(\d+)\s+(\S): (\S+)}, line),
         {min, _} <- Integer.parse(minb),
         {max, _} <- Integer.parse(maxb) do
      %{
        min: min,
        max: max,
        char: char,
        password: password
      }
    end
  end

  def good_password?(%{min: min, max: max, char: char, password: password}) do
    count =
      password
      |> String.graphemes()
      |> Enum.count(&(&1 == char))

    min <= count && count <= max
  end

  def good_password_count(list), do: Enum.count(list, &good_password?/1)

  def new_good_password?(%{min: pos1, max: pos2, char: char, password: password}) do
    with match1 <- String.at(password, pos1 - 1) == char,
         match2 <- String.at(password, pos2 - 1) == char do
      (match1 or match2) and not (match1 and match2)
    end
  end

  def new_good_password_count(list), do: Enum.count(list, &new_good_password?/1)
end
