require "board.rb"

class BasicOpponent
  def initialize
    @store = 7
    @houses = [4, 5, 6, 8, 9, 10]
  end

  def pick_house_from(seeds)
    get_nonempty_houses(seeds).sample.to_i
  end

  def get_nonempty_houses(seeds)
    nonempty_houses = []
    @houses.each do |house|
      nonempty_houses << house unless seeds[house].zero?
    end
    nonempty_houses
  end
end


class GreedyOpponent < BasicOpponent

  def pick_house_from(seeds)
    possible_houses = get_nonempty_houses(seeds)
    scores = {}
    possible_houses.each do |house|
      b = Board.new(0, seeds.dup)
      status = b.sow_seeds_from house
      scores[house] = b.remaining_seeds
      scores[house] += 2 if status == :again
    end
    scores.max_by {|_, v| v}.first
  end
end