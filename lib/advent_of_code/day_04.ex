defmodule AdventOfCode.Day04 do
  @required_keys MapSet.new(~w[byr iyr eyr hgt hcl ecl pid]a)

  def part1(args) when is_list(args), do: Enum.count(args, &valid_passport?/1)

  def part1(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part1()
  end

  def part1(), do: part1("./data/day04.txt")

  def part2(args) when is_list(args), do: Enum.count(args, &really_valid_passport?/1)

  def part2(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part2()
  end

  def part2(), do: part2("./data/day04.txt")

  def read_from_file(filename) do
    filename
    |> File.read!()
    |> parse_file()
  end

  def parse_file(content) when is_binary(content) do
    content
    |> String.split(~r{\s*\n\s*\n\s*})
    |> Enum.reject(&String.match?(&1, ~r/^\s*$/))
    |> Enum.map(&parse_passport/1)
  end

  def parse_passport(chunk) do
    chunk
    |> String.split(~r{\s+})
    |> Enum.reject(fn x -> x == "" end)
    |> Map.new(fn <<key::binary-3, ":", value::binary>> ->
      {String.to_atom(key), value}
    end)
  end

  def valid_passport?(passport) do
    keys = MapSet.new(Map.keys(passport))
    MapSet.size(MapSet.difference(@required_keys, keys)) == 0
  end

  def really_valid_passport?(passport) do
    valid_birthdate?(passport) and
      valid_issue_year?(passport) and
      valid_expiration_year?(passport) and
      valid_height?(passport) and
      valid_hair_color?(passport) and
      valid_eye_color?(passport) and
      valid_passport_id?(passport)
  end

  def valid_four_digit_number?(n, min, max) do
    if String.length(n) == 4 do
      case Integer.parse(n) do
        {int, ""} -> max >= int and int >= min
        _ -> false
      end
    else
      false
    end
  end

  def valid_birthdate?(%{byr: byr}), do: valid_four_digit_number?(byr, 1920, 2002)
  def valid_birthdate?(_), do: false

  def valid_issue_year?(%{iyr: iyr}), do: valid_four_digit_number?(iyr, 2010, 2020)
  def valid_issue_year?(_), do: false

  def valid_expiration_year?(%{eyr: eyr}), do: valid_four_digit_number?(eyr, 2020, 2030)
  def valid_expiration_year?(_), do: false

  def valid_height?(%{hgt: hgt}) do
    case Integer.parse(hgt) do
      {cm, "cm"} -> 193 >= cm and cm >= 150
      {inches, "in"} -> 76 >= inches and inches >= 59
      _ -> false
    end
  end

  def valid_height?(_), do: false

  def valid_hair_color?(%{hcl: hcl}), do: Regex.match?(~r/^\#[0-9a-f]{6}$/, hcl)
  def valid_hair_color?(_), do: false

  def valid_eye_color?(%{ecl: ecl}), do: ecl in ~w[amb blu brn gry grn hzl oth]
  def valid_eye_color?(_), do: false

  def valid_passport_id?(%{pid: pid}), do: Regex.match?(~r/^[0-9]{9}$/, pid)
  def valid_passport_id?(_), do: false
end
