defmodule AdventOfCode.Day15 do
  def part1(args) do
    args
    |> init_plays()
    |> play_rounds(2020 - Enum.count(args))
    |> elem(0)
  end

  def part1(), do: part1([17, 1, 3, 16, 19, 0])

  def part2(args) do
    args
    |> init_plays()
    |> play_rounds(30_000_000 - Enum.count(args))
    |> elem(0)
  end

  def part2(), do: part2([17, 1, 3, 16, 19, 0])

  def init_plays([first | rest]) do
    rest
    |> Enum.reduce({first, %{}, 1}, fn x, {last_play, plays, play_count} ->
      {x, Map.put(plays, last_play, play_count), play_count + 1}
    end)
  end

  def next_play({last_play, past_plays, play_count} = _plays) do
    play_count - Map.get(past_plays, last_play, play_count)
  end

  def play_round({last_play, past_plays, play_count} = plays) do
    next_play = next_play(plays)
    {next_play, Map.put(past_plays, last_play, play_count), play_count + 1}
  end

  def play_rounds(plays, 0), do: plays

  def play_rounds(plays, rounds) do
    plays
    |> play_round()
    |> play_rounds(rounds - 1)
  end
end
