defmodule AdventOfCode.Day16 do
  def part1(), do: part1("./data/day16.txt")

  def part1(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part1()
  end

  def part1(%{other_tickets: other_tickets} = state) do
    other_tickets
    |> Enum.concat()
    |> find_invalid_values(state)
    |> Enum.sum()
  end

  def part2(), do: part2("./data/day16.txt")

  def part2(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part2()
  end

  def part2(state) do
    state
    |> discard_invalid_tickets()
    |> discover_field_mapping()
    |> select_departure_fields()
    |> Enum.reduce(1, fn x, y -> x * y end)
  end

  def read_from_file(filename) do
    filename
    |> File.read!()
    |> parse_file()
  end

  def parse_file(content) do
    [rules, your_ticket, nearby_tickets] = String.split(content, ~r{\s*\n\s*\n\s*}, trim: true)

    %{
      rules: parse_rules(rules),
      your_ticket: parse_your_ticket(your_ticket),
      other_tickets: parse_other_tickets(nearby_tickets),
      field_mapping: []
    }
  end

  def parse_rules(content) do
    content
    |> String.split(~r{\s*\n\s*}, trim: true)
    |> Map.new(&parse_rule/1)
  end

  def parse_rule(line) do
    [name, rule] = String.split(line, ~r{:\s*}, parts: 2)
    rules = String.split(rule, ~r{\s*or\s*})

    ranges =
      rules
      |> IO.inspect()
      |> Enum.map(fn r ->
        [l, r] = String.split(r, "-")
        {l, ""} = Integer.parse(l)
        {r, ""} = Integer.parse(r)
        Range.new(l, r)
      end)

    {name, ranges}
  end

  def parse_your_ticket(content) do
    content
    |> parse_other_tickets()
    |> List.first()
  end

  def parse_other_tickets(content) do
    [_ | lines] = String.split(content, ~r{\s*\n\s*}, trim: true)
    Enum.map(lines, &parse_ticket/1)
  end

  def parse_ticket(line) do
    line
    |> String.split(~r{\s*,\s*})
    |> Enum.map(fn x ->
      x |> Integer.parse() |> elem(0)
    end)
  end

  def find_invalid_values(state, values) when is_list(values) do
    find_invalid_values(values, state)
  end

  def find_invalid_values(values, state) when is_list(values) do
    ranges_list = all_ranges(state)
    Enum.filter(values, &invalid_value?(ranges_list, &1))
  end

  def all_ranges(%{rules: rules}) do
    rules
    |> Map.values()
    |> Enum.concat()
  end

  def invalid_value?(ranges, value), do: not Enum.any?(ranges, &Enum.member?(&1, value))

  def invalid_ticket?(ranges, values) do
    Enum.any?(values, &invalid_value?(ranges, &1))
  end

  def discard_invalid_tickets(%{other_tickets: other_tickets} = state) do
    ranges = all_ranges(state)

    valid_other_tickets =
      other_tickets
      |> Enum.reject(&invalid_ticket?(ranges, &1))

    %{state | other_tickets: valid_other_tickets}
  end

  def tickets_to_columns(tickets) do
    as_tuples =
      tickets
      |> Enum.map(&List.to_tuple/1)
      |> List.to_tuple()

    for j <- 0..(Enum.count(List.first(tickets)) - 1) do
      for i <- 0..(Enum.count(tickets) - 1) do
        as_tuples
        |> elem(i)
        |> elem(j)
      end
    end
  end

  def find_valid_rules(values, rules) do
    rules
    |> Enum.reject(fn {name, ranges} -> invalid_ticket?(ranges, values) end)
    |> Enum.map(&elem(&1, 0))
  end

  def has_multiple_entries?([_, _ | _]), do: true
  def has_multiple_entries?(_), do: false

  def sort_rules_to_columns(possible_mapping) do
    needs_work = Enum.any?(possible_mapping, &has_multiple_entries?/1)

    if needs_work do
      singles =
        possible_mapping
        |> Enum.reject(&has_multiple_entries?/1)
        |> Enum.concat()

      possible_mapping
      |> Enum.map(fn
        [_, _ | _] = m -> m -- singles
        m -> m
      end)
      |> sort_rules_to_columns()
    else
      possible_mapping
    end
  end

  def make_field_mapping(mapping) do
    mapping
    |> Enum.with_index()
    |> Map.new(fn {[m], i} -> {m, i} end)
  end

  def discover_field_mapping(%{rules: rules, other_tickets: other_tickets} = state) do
    as_columns = tickets_to_columns(other_tickets)
    # now see which rules each column allows
    rules_list = Map.to_list(rules)

    possible_rules =
      as_columns
      |> Enum.map(&find_valid_rules(&1, rules))

    # all columns that only allow a single rule have to use that rule
    mapping =
      possible_rules
      |> sort_rules_to_columns()
      |> make_field_mapping()

    %{state | field_mapping: mapping}
  end

  def select_departure_fields(%{your_ticket: ticket, field_mapping: mapping}) do
    mapping
    |> Map.to_list()
    |> Enum.filter(fn {m, _} -> String.starts_with?(m, "departure ") end)
    |> Enum.map(fn {_, i} -> Enum.at(ticket, i) end)
  end
end
