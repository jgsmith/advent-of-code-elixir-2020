defmodule AdventOfCode.Day23 do
  def part1(list) when is_binary(list) do
    list
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> circle()
    |> part1()
  end

  def part1(queue) do
    queue
    |> rounds(100)
    |> to_output
  end

  def part2(list) when is_binary(list) do
    list
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> circle(1_000_000)
    |> part2()
  end

  def part2(queue) do
    queue = rounds(queue, 10_000_000)
    {[a, b], _} = pull(queue, 2, 1, [])
    a * b
  end

  def circle(items) do
    circle(items, Enum.count(items))
  end

  def circle([first_item | _] = items, maxn) do
    # act as if it's a linked list, but use a balanced tree to manage the data structure to minimize
    # copies.
    n = Enum.count(items)
    tail_item = if n < maxn, do: n + 1, else: List.first(items)

    gbt =
      items
      |> Enum.zip(Enum.drop(items, 1) ++ [tail_item])
      |> Enum.reduce(:gb_trees.empty(), fn {item, next_item}, tree ->
        :gb_trees.insert(item, next_item, tree)
      end)

    gbt =
      if n < maxn do
        [gbt] =
          (n + 1)..maxn
          |> Stream.zip((n + 2)..maxn)
          |> Stream.scan(gbt, fn {item, next_item}, tree ->
            :gb_trees.insert(item, next_item, tree)
          end)
          |> Enum.drop(maxn - n - 2)

        :gb_trees.insert(maxn, List.first(items), gbt)
      else
        gbt
      end

    # tree, position, total size
    {gbt, first_item, maxn}
  end

  def to_output({gbt, _, _} = circle, pos \\ 1, acc \\ []) do
    next = :gb_trees.get(pos, gbt)

    if next == 1 do
      acc
      |> Enum.reverse()
      |> Enum.join("")
    else
      to_output(circle, next, [next | acc])
    end
  end

  def advance_pointer({gbt, pos, maxn}) do
    {gbt, :gb_trees.get(pos, gbt), maxn}
  end

  # pulls the _count_ items after _pos_, but doesn't return _pos_ as part of that
  def pull({gbt, pos, _} = circle, count) do
    next = :gb_trees.get(pos, gbt)
    pull(circle, count - 1, next, [next])
  end

  def pull(circle, count, pos, acc \\ [])

  def pull({gbt, pos, maxn}, 0, last_pos, acc) do
    {Enum.reverse(acc), {:gb_trees.update(pos, :gb_trees.get(last_pos, gbt), gbt), pos, maxn}}
  end

  def pull({gbt, _, _} = circle, count, pos, acc) do
    next = :gb_trees.get(pos, gbt)
    pull(circle, count - 1, next, [next | acc])
  end

  def peek({_, pos, _}), do: pos

  def put({gbt, pos, maxn}, pole, items) do
    [first | _] = items
    [last | _] = Enum.reverse(items)
    old_next = :gb_trees.get(pole, gbt)
    {:gb_trees.update(pole, first, :gb_trees.update(last, old_next, gbt)), pos, maxn}
  end

  def next_lower_cup(circle, cup, missing \\ [])

  def next_lower_cup({_, _, maxn} = circle, 1, missing),
    do: next_lower_cup(circle, maxn + 1, missing)

  def next_lower_cup({_, _, maxn} = circle, cup, missing) do
    if (cup - 1) in missing, do: next_lower_cup(circle, cup - 1, missing), else: cup - 1
  end

  def cup_round(circle) do
    current = peek(circle)
    {cups, circle} = pull(circle, 3)
    destination = next_lower_cup(circle, current, cups)

    circle
    |> put(destination, cups)
    |> advance_pointer()
  end

  def rounds(circle, 0), do: circle

  def rounds(circle, count) do
    circle
    |> cup_round()
    |> rounds(count - 1)
  end
end
