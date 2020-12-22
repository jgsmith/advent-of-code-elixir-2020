defmodule AdventOfCode.Day22 do
  def part1(), do: part1("./data/day22.txt")

  def part1(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part1()
  end

  def part1(players) do
    players
    |> play_game()
    |> score_game()
  end

  def part2(), do: part2("./data/day22.txt")

  def part2(filename) when is_binary(filename) do
    filename
    |> read_from_file()
    |> part2()
  end

  def part2(players) do
    players
    |> start_game()
    |> play_game2()
    |> score_game()
  end

  def start_game(players) do
    {players, MapSet.new()}
  end

  def read_from_file(filename) do
    filename
    |> File.read!()
    |> parse_file()
  end

  def parse_file(content) do
    [player1, player2] = String.split(content, ~r{\s*\n\n\s*}, trim: true)
    {parse_hand(player1), parse_hand(player2)}
  end

  def parse_hand(lines) do
    lines
    |> String.split(~r{\s*\n\s*}, trim: true)
    |> Enum.drop(1)
    |> Enum.map(&String.to_integer/1)
    |> build_hand()
  end

  def build_hand(cards) do
    :queue.from_list(cards)
  end

  def play_round({hand1, hand2}) do
    {card1, hand1} = take_card(hand1)
    {card2, hand2} = take_card(hand2)

    if card1 > card2 do
      {place_cards(hand1, card1, card2), hand2}
    else
      {hand1, place_cards(hand2, card2, card1)}
    end
  end

  def play_game(players) do
    if game_over?(players) do
      players
    else
      players
      |> play_round()
      |> play_game()
    end
  end

  def take_card(hand) do
    case :queue.out(hand) do
      {{:value, card}, remaining_hand} -> {card, remaining_hand}
      {:empty, _} -> {nil, hand}
    end
  end

  def place_cards(hand, card1, card2) do
    :queue.in(card2, :queue.in(card1, hand))
  end

  def game_over?({{_, _} = players, %MapSet{} = history}) do
    game_over?(players) or MapSet.member?(history, round_signature(players))
  end

  def game_over?({hand1, hand2}), do: losing_hand?(hand1) or losing_hand?(hand2)

  def winner({players, %MapSet{} = history}) do
    if MapSet.member?(history, round_signature(players)) do
      :player1
    else
      winner(players)
    end
  end

  def winner({hand1, hand2}), do: if(losing_hand?(hand1), do: :player2, else: :player1)

  def score_game({{hand1, hand2} = players, %MapSet{} = _history} = game) do
    case winner(game) do
      :player1 -> score_hand(hand1)
      :player2 -> score_hand(hand2)
    end
  end

  def score_game({hand1, hand2}), do: score_hand(hand1) + score_hand(hand2)

  def losing_hand?(hand), do: :queue.is_empty(hand)

  def score_hand(hand) do
    hand
    |> :queue.to_list()
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.map(fn {c, i} -> c * (i + 1) end)
    |> Enum.sum()
  end

  def add_history({players, %MapSet{} = history}) do
    {players, MapSet.put(history, round_signature(players))}
  end

  def round_signature({hand1, hand2}) do
    sig1 =
      hand1
      |> :queue.to_list()
      |> Enum.join(",")

    sig2 =
      hand2
      |> :queue.to_list()
      |> Enum.join(",")

    "#{sig1}:#{sig2}"
  end

  def play_game2({players, _} = game) do
    if game_over?(game) do
      game
    else
      game
      |> add_history()
      |> play_round2()
      |> play_game2()
    end
  end

  def replicate(hand, count) do
    hand
    |> :queue.to_list()
    |> Enum.take(count)
    |> build_hand()
  end

  def play_round2({{hand1, hand2} = players, history}) do
    {card1, new_hand1} = take_card(hand1)
    {card2, new_hand2} = take_card(hand2)

    winner =
      cond do
        card1 <= cards_in_hand(new_hand1) and card2 <= cards_in_hand(new_hand2) ->
          # recursion - not the greatest use of elixir, but /shrug
          play_subround({replicate(new_hand1, card1), replicate(new_hand2, card2)})

        card1 > card2 ->
          :player1

        :else ->
          :player2
      end

    case winner do
      :player1 ->
        {{place_cards(new_hand1, card1, card2), new_hand2}, history}

      :player2 ->
        {{new_hand1, place_cards(new_hand2, card2, card1)}, history}
    end
  end

  def play_subround(players) do
    players
    |> start_game()
    |> play_game2()
    |> winner()
  end

  def cards_in_hand(hand), do: :queue.len(hand)
end
