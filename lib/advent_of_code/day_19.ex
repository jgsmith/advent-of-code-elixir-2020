defmodule AdventOfCode.Day19 do
  def part1(), do: part1("./data/day19.txt")

  def part1(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part1()
  end

  def part1(state) do
    count_rule_matches(state, 0)
  end

  def part2(), do: part2("./data/day19.txt")

  def part2(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part2()
  end

  def part2(state) do
    count_revised_rule_matches(state, 0)
  end

  def read_from_file(filename) do
    filename
    |> File.read!()
    |> parse_file()
  end

  def parse_file(content) do
    [rule_content, line_content] = String.split(content, ~r{\s*\n\n\s*}, parts: 2, trim: true)

    rules =
      rule_content
      |> String.split(~r{\s*\n\s*}, trim: true)
      |> Map.new(&parse_rule_line/1)

    lines = line_content |> String.split(~r{\s*\n\s*}, trim: true)
    {rules, lines}
  end

  def parse_rule_line(line) do
    [rule_num, rule_pat] = String.split(line, ~r{\s*:\s*}, parts: 2, trim: true)

    rule_pat_parts =
      rule_pat
      |> String.split(~r{\s*\|\s*}, trim: true)
      |> Enum.map(&parse_rule_part/1)

    rule_num_int = String.to_integer(rule_num)
    {rule_num_int, rule_pat_parts}
  end

  def parse_rule_part(<<"\"", letter::binary-1, "\"">>) do
    letter
  end

  def parse_rule_part(number_list) do
    number_list
    |> String.split(~r{\s+}, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def count_rule_matches({_, lines} = state, rule_num) do
    rule_regexes = build_regexes(state)
    {:ok, regex} = Regex.compile("^" <> Map.get(rule_regexes, rule_num) <> "$")
    Enum.count(lines, &Regex.match?(regex, &1))
  end

  def count_revised_rule_matches({_, lines} = state, rule_num) do
    rule_regexes = build_revised_regexes(state)
    {:ok, regex} = Regex.compile("^" <> Map.get(rule_regexes, rule_num) <> "$")
    Enum.count(lines, &Regex.match?(regex, &1))
  end

  def build_revised_regexes({rules, _} = state) do
    build_order =
      state
      |> build_rule_graph()
      |> :digraph_utils.topsort()
      |> Enum.reverse()

    build_order
    |> Enum.reduce(Map.new(), fn rule_num, built ->
      Map.put(built, rule_num, build_revised_regex(rule_num, Map.get(rules, rule_num), built))
    end)
  end

  def build_regexes({rules, _} = state) do
    build_order =
      state
      |> build_rule_graph()
      |> :digraph_utils.topsort()
      |> Enum.reverse()

    build_order
    |> Enum.reduce(Map.new(), fn rule_num, built ->
      Map.put(built, rule_num, build_regex(rule_num, Map.get(rules, rule_num), built))
    end)
  end

  def build_regex(rule_num, [rule_def], built) when is_binary(rule_def), do: rule_def

  def build_regex(rule_num, rule_def, built) do
    # rule_def is a list of list of rule numbers
    # they should all be present in _built_
    txt =
      rule_def
      |> Enum.map(fn rule_list ->
        rule_list
        |> Enum.map(fn r -> Map.get(built, r) end)
        |> Enum.join("")
      end)
      |> Enum.join("|")

    "(" <> txt <> ")"
  end

  def build_revised_regex(8, _, built) do
    # 8: 42 | 42 8
    rule_42 = Map.get(built, 42)
    "(#{rule_42})+"
  end

  def build_revised_regex(11, _, built) do
    # 11: 42 31 | 42 11 31
    rule_42 = Map.get(built, 42)
    rule_31 = Map.get(built, 31)

    "(#{rule_42}#{rule_31}|#{rule_42}#{rule_42}#{rule_31}#{rule_31}|#{rule_42}#{rule_42}#{rule_42}#{
      rule_31
    }#{rule_31}#{rule_31}|#{rule_42}#{rule_42}#{rule_42}#{rule_42}#{rule_31}#{rule_31}#{rule_31}#{
      rule_31
    })"
  end

  def build_revised_regex(n, r, b), do: build_regex(n, r, b)

  def build_rule_graph(state) do
    graph = :digraph.new()
    build_rule_graph(state, graph)
  end

  def build_rule_graph({rules, _}, graph) do
    build_rule_graph(Map.to_list(rules), graph)
  end

  def build_rule_graph([], graph), do: graph

  def build_rule_graph([{_, [a]} | rest], graph) when is_binary(a) do
    build_rule_graph(rest, graph)
  end

  def build_rule_graph([{rule_num, rule_def} | rest], graph) do
    rule_num_v = :digraph.add_vertex(graph, rule_num)

    needed_rules =
      rule_def
      |> Enum.reduce(MapSet.new(), fn l, s ->
        Enum.reduce(l, s, fn i, set -> MapSet.put(set, i) end)
      end)

    for i <- MapSet.to_list(needed_rules) do
      if i != rule_num do
        i_v = :digraph.add_vertex(graph, i)
        :digraph.add_edge(graph, rule_num_v, i_v)
      end
    end

    build_rule_graph(rest, graph)
  end
end
