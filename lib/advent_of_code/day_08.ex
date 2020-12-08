defmodule AdventOfCode.Day08 do
  def part1(), do: part1("./data/day08.txt")

  def part1(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part1()
  end

  def part1(computer) do
    %{acc: acc} = run_until_loop(computer)
    acc
  end

  def part2(), do: part2("./data/day08.txt")

  def part2(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part2()
  end

  def part2(computer) do
    %{acc: acc} = tune_computer(computer)
    acc
  end

  def read_from_file(filename) do
    filename
    |> File.read!()
    |> parse_file()
  end

  def parse_file(content) do
    rom =
      content
      |> String.split(~r{\s*\n\s*}, trim: true)
      |> compile_lines

    %{
      rom: rom,
      rom_overlay: %{},
      pc: 0,
      acc: 0,
      visited: MapSet.new(),
      status: nil
    }
  end

  def compile_lines(lines) do
    lines
    |> Enum.map(&compile_line/1)
    |> List.to_tuple()
  end

  def compile_line(<<op::binary-3, " ", arg::binary>>) do
    {n, ""} = Integer.parse(arg)
    {String.to_atom(op), n}
  end

  def run_until_loop(computer) do
    cond do
      been_here_before?(computer) ->
        %{computer | status: :looped}

      not here_exists?(computer) ->
        %{computer | status: :exited}

      :else ->
        computer
        |> run_step()
        |> run_until_loop()
    end
  end

  def been_here_before?(%{visited: visited, pc: pc}), do: MapSet.member?(visited, pc)

  def here_exists?(%{pc: pc, rom: rom}), do: pc < tuple_size(rom)

  def run_step(%{pc: pc} = computer) do
    step(computer, peek(computer, pc))
  end

  def step(computer, {:nop, _}), do: modify_computer(computer, 1, 0)
  def step(computer, {:acc, n}), do: modify_computer(computer, 1, n)
  def step(computer, {:jmp, n}), do: modify_computer(computer, n, 0)

  def modify_computer(%{pc: pc, visited: visited, acc: acc} = computer, jump, add) do
    %{computer | pc: pc + jump, acc: acc + add, visited: MapSet.put(visited, pc)}
  end

  # find a single change that will break the loop
  def tune_computer(computer) do
    %{visited: visited} = looped_computer = run_until_loop(computer)

    visited
    |> MapSet.to_list()
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.find_value(fn pc ->
      there_now = peek(computer, pc)

      %{status: status} =
        run_computer = run_until_loop(poke(computer, pc, alternate_inst(there_now)))

      if status == :looped, do: false, else: run_computer
    end)
  end

  def poke(%{rom_overlay: overlay} = computer, addr, value) do
    %{computer | rom_overlay: Map.put(overlay, addr, value)}
  end

  def peek(%{rom: rom, rom_overlay: overlay}, addr), do: Map.get(overlay, addr, elem(rom, addr))

  def alternate_inst({:nop, n}), do: {:jmp, n}
  def alternate_inst({:jmp, n}), do: {:nop, n}
  def alternate_inst(inst), do: inst
end
