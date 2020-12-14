defmodule AdventOfCode.Day14 do
  use Bitwise

  def part1(), do: part1("./data/day14.txt")

  def part1(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part1()
  end

  def part1(args) do
    args
    |> runv1()
    |> sum_memory()
  end

  def part2(), do: part2("./data/day14.txt")

  def part2(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part2()
  end

  def part2(args) do
    args
    |> runv2()
    |> sum_memory()
  end

  def read_from_file(filename) do
    filename
    |> File.read!()
    |> parse_file()
  end

  def parse_file(content) do
    content
    |> String.split(~r{\s*\n\s*}, trim: true)
    |> Enum.map(&parse/1)
  end

  def parse(<<"mask = ", mask::binary>>) do
    {:mask, mask}
  end

  def parse(<<"mem[", rest::binary>>) do
    [loc_s, val_s] = String.split(rest, "] = ", parts: 2)
    {loc, ""} = Integer.parse(loc_s)
    {val, ""} = Integer.parse(val_s)
    {:set, loc, val}
  end

  def sum_memory(memory) do
    memory
    |> Map.values()
    |> Enum.sum()
  end

  ### Part 1

  def runv1(instructions, masker \\ nil, memory \\ %{})
  def runv1([], _, memory), do: memory

  def runv1([inst | rest], masker, memory) do
    case inst do
      {:mask, new_m} -> runv1(rest, new_m, memory)
      {:set, loc, val} -> runv1(rest, masker, Map.put(memory, loc, mask(val, masker)))
    end
  end

  def mask(val, nil), do: val

  def mask(val, masker) do
    {ander, ""} =
      masker
      |> String.replace("X", "1")
      |> Integer.parse(2)

    {orer, ""} =
      masker
      |> String.replace("X", "0")
      |> Integer.parse(2)

    (val &&& ander) ||| orer
  end

  ### Part 2

  def runv2(instructions, masker \\ nil, memory \\ %{})
  def runv2([], _, memory), do: memory

  def runv2([inst | rest], masker, memory) do
    case inst do
      {:mask, new_m} -> runv2(rest, new_m, memory)
      {:set, loc, val} -> runv2(rest, masker, load_memory(memory, loc, masker, val))
    end
  end

  def load_memory(memory, loc, masker, val) do
    loc
    |> generate_addresses(masker)
    |> Enum.reduce(memory, fn addr, mem -> Map.put(mem, addr, val) end)
  end

  def generate_addresses(loc, masker) do
    slots =
      loc
      |> Integer.to_string(2)
      |> String.pad_leading(String.length(masker), "0")
      |> slice_loc(masker)

    num_bits = Enum.count(slots) - 1
    max = (1 <<< num_bits) - 1

    for i <- 0..max do
      i
      |> Integer.to_string(2)
      |> String.pad_leading(num_bits, "0")
      |> String.split("", trim: true)
      |> build_loc(slots)
    end
  end

  def build_loc(bits, slots, acc \\ [])

  def build_loc([], [], acc) do
    acc
    |> Enum.reverse()
    |> Enum.join("")
    |> Integer.parse(2)
    |> elem(0)
  end

  def build_loc([bit], [], acc), do: build_loc([], [], [bit | acc])
  def build_loc([], [slot], acc), do: build_loc([], [], [slot | acc])

  def build_loc([bit | bits], [slot | slots], acc) do
    build_loc(bits, slots, [bit, slot | acc])
  end

  def slice_loc(loc, masker, acc \\ "", segments \\ [])
  def slice_loc("", "", acc, segments), do: Enum.reverse([acc | segments])

  def slice_loc(<<_::binary-1, rest_loc::binary>>, <<"X", rest_masker::binary>>, acc, segments) do
    slice_loc(rest_loc, rest_masker, "", [acc | segments])
  end

  def slice_loc(<<_::binary-1, rest_loc::binary>>, <<"1", rest_masker::binary>>, acc, segments) do
    slice_loc(rest_loc, rest_masker, acc <> "1", segments)
  end

  def slice_loc(
        <<digit::binary-1, rest_loc::binary>>,
        <<"0", rest_masker::binary>>,
        acc,
        segments
      ) do
    slice_loc(rest_loc, rest_masker, acc <> digit, segments)
  end
end
