defmodule AdventOfCode.Day10 do
  def part1(), do: part1("./data/day10.txt")

  def part1(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part1()
  end

  def part1(args) when is_list(args) do
    count_differences(args, 1) * (1 + count_differences(args, 3))
  end

  def part2(), do: part2("./data/day10.txt")

  def part2(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part2()
  end

  def part2(args) do
    count_ways([0 | args])
  end

  def read_from_file(filename) do
    filename
    |> File.read!()
    |> parse_file()
  end

  def parse_file(content) do
    content
    |> String.split(~r{\s*\n\s*}, trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
  end

  def count_differences(joltages, diff) do
    [0 | joltages]
    |> Enum.zip(joltages)
    |> Enum.count(fn {x, y} -> y - x == diff end)
  end

  def count_ways(joltages) do
    graph = build_graph(joltages)
    annotate_nodes_with_counts(graph)
    {_, count} = :digraph.vertex(graph, 0)
    count
  end

  def build_graph(joltages) do
    graph = :digraph.new()
    build_graph(graph, joltages)
  end

  def build_graph(graph, []), do: graph

  def build_graph(graph, [root | rest]) do
    reachable = Enum.take_while(rest, fn x -> x - root <= 3 end)
    root_v = :digraph.add_vertex(graph, root, 0)

    for node <- reachable do
      node_v = :digraph.add_vertex(graph, node, 0)
      :digraph.add_edge(graph, root_v, node_v)
    end

    build_graph(graph, rest)
  end

  def annotate_nodes_with_counts(graph) do
    leaves = get_leaves(graph)

    for leaf <- leaves do
      :digraph.add_vertex(graph, leaf, 1)
    end

    nodes =
      graph
      |> :digraph_utils.topsort()
      |> Enum.reverse()

    for node <- nodes do
      {_, count} = :digraph.vertex(graph, node)
      parent_nodes = :digraph.in_neighbours(graph, node)

      for parent_node <- parent_nodes do
        {_, n} = :digraph.vertex(graph, parent_node)
        :digraph.add_vertex(graph, parent_node, n + count)
      end
    end
  end

  def get_leaves(graph) do
    graph
    |> :digraph.vertices()
    |> Enum.filter(fn v ->
      :digraph.out_degree(graph, v) == 0
    end)
  end
end
