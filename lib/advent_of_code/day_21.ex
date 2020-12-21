defmodule AdventOfCode.Day21 do
  def part1(), do: part1("./data/day21.txt")

  def part1(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part1()
  end

  def part1(args) do
    count_ingredients_lacking_allergens(args)
  end

  def part2(), do: part2("./data/day21.txt")

  def part2(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part2()
  end

  def part2(args) do
    args
    |> allergen_ingredients()
    |> Map.to_list()
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map(fn {_, i} -> MapSet.to_list(i) end)
    |> Enum.reduce(&Enum.concat/2)
    |> Enum.reverse()
    |> Enum.join(",")
  end

  def read_from_file(filename) do
    filename
    |> File.read!()
    |> parse_file()
  end

  def parse_file(content) do
    content
    |> String.split(~r{\s*\n\s*}, trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    [ingredients_list, allergens_list] = String.split(line, ~r{\s*\(contains\s+}, parts: 2)

    ingredients =
      ingredients_list
      |> String.split(~r{\s+}, trim: true)
      |> MapSet.new()

    allergens =
      allergens_list
      |> String.replace_suffix(")", "")
      |> String.split(~r{\s*,\s*}, trim: true)
      |> MapSet.new()

    {allergens, ingredients}
  end

  def all_allergens(recipes) do
    Enum.reduce(recipes, MapSet.new(), fn {a, _}, acc -> MapSet.union(a, acc) end)
  end

  def all_ingredients_for_allergen(allergen, recipes) do
    recipes
    |> Enum.filter(fn {a, _} -> MapSet.member?(a, allergen) end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.reduce(&MapSet.intersection(&1, &2))
  end

  def all_ingredients_that_might_have_allergens(recipes) do
    recipes
    |> all_allergens
    |> Enum.map(&all_ingredients_for_allergen(&1, recipes))
    |> Enum.reduce(&MapSet.union(&1, &2))
  end

  def count_ingredients_lacking_allergens(recipes) do
    bad_ingredients = all_ingredients_that_might_have_allergens(recipes)

    recipes
    |> Enum.map(fn {_, i} ->
      i
      |> MapSet.difference(bad_ingredients)
      |> MapSet.size()
    end)
    |> Enum.sum()
  end

  def allergen_ingredients(recipes) do
    recipes
    |> all_allergens
    |> Map.new(fn a -> {a, all_ingredients_for_allergen(a, recipes)} end)
    |> clean_ingredients_list
  end

  def clean_ingredients_list(mapping) do
    if Enum.any?(mapping, fn {_, i} -> MapSet.size(i) > 1 end) do
      singles =
        mapping
        |> Enum.filter(fn {_, i} -> MapSet.size(i) == 1 end)
        |> Enum.reduce(MapSet.new(), fn {_, i}, acc -> MapSet.union(i, acc) end)

      mapping
      |> Enum.reduce(%{}, fn {a, i}, acc ->
        if MapSet.size(i) == 1 do
          Map.put(acc, a, i)
        else
          Map.put(acc, a, MapSet.difference(i, singles))
        end
      end)
      |> clean_ingredients_list
    else
      mapping
    end
  end
end
