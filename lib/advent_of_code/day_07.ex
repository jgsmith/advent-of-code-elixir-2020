defmodule AdventOfCode.Day07 do
  def part1(), do: part1("./data/day07.txt")

  def part1(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part1()
  end

  def part1(context) do
    context
    |> find_containing_roots("shiny gold")
    |> Enum.count()
  end

  def part2(), do: part2("./data/day07.txt")

  def part2(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part2()
  end

  def part2(context) do
    find_bag_count_closure(context, "shiny gold") - 1
  end

  def read_from_file(filename) do
    filename
    |> File.read!()
    |> parse_file()
  end

  def parse_file(content) do
    rules =
      content
      |> String.split(~r{\s*\n\s*}, trim: true)
      |> Enum.map(&parse_bag_rule/1)

    graph = :digraph.new()

    rules
    |> Enum.each(fn {root, children} ->
      root_v = :digraph.add_vertex(graph, root)

      for {color, count} <- children do
        if color != "other" do
          child_v = :digraph.add_vertex(graph, color)
          :digraph.add_edge(graph, root_v, child_v, count)
        end
      end
    end)

    outter_bags =
      rules
      |> Enum.map(fn {color, _} -> color end)

    {graph, outter_bags}
  end

  @spec parse_bag_rule(String.t()) :: {String.t(), [{String.t(), integer}]}
  def parse_bag_rule(line) do
    # (.*) bags contain (\d+) (.*)
    [root_node, rest] = String.split(line, ~r{\s+bags?\s+contains?\s+}, parts: 2, trim: true)

    child_bags =
      String.split(Regex.replace(~r{\s+bags?\.$}, rest, ""), ~r{\s*bags?,\s*}, trim: true)

    children =
      for child_bag <- child_bags do
        [count, color] = String.split(child_bag, ~r{\s+}, parts: 2)

        if count == "no" do
          {color, 0}
        else
          {n, ""} = Integer.parse(count)
          {color, n}
        end
      end

    {root_node, children}
  end

  def find_containing_roots({graph, outter_bags}, node) do
    outter_bags
    |> Enum.filter(fn outter_bag ->
      case :digraph.get_path(graph, outter_bag, node) do
        false -> false
        _ -> true
      end
    end)
  end

  def find_bag_count_closure({graph, _} = context, node) do
    in_node_count =
      graph
      |> :digraph.edges(node)
      |> Enum.map(&:digraph.edge(graph, &1))
      |> Enum.filter(fn {_, v1, _, _} -> v1 == node end)
      |> Enum.map(fn {_, _, v2, count} ->
        count * find_bag_count_closure(context, v2)
      end)
      |> Enum.sum()

    in_node_count + 1
  end
end
