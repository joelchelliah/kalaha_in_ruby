class Board
  attr_reader :seeds_in_houses

  def initialize(n, flipped = nil)
    @seeds_in_houses = flipped || [0, n, n, n, n, n, n, 0, n, n, n, n, n, n]
    @player_store = 7
    @player_houses = [4, 5, 6, 8, 9, 10]

    #@stores = {one: 7, two: 0}
    #@house_groups = {one: [4, 5, 6, 8, 9, 10], two: [1, 2, 3, 11, 12, 13]}
  end

  def show
    s = @seeds_in_houses.each_with_index.map do |seeds, house|
      if house == 7 or @player_houses.include? house
        seeds.to_s.ljust(2)
      else
        seeds.to_s.rjust(2)
      end
    end
    puts "-".center(29, "-")
    puts "   | " << s[1..3].join(" ") << " : " << s[4..6].join(" ") << " |"
    puts s[0] << " |          :          | " << s[7]
    puts "   | " << s[11..13].reverse.join(" ") << " : " << s[8..10].reverse.join(" ") << " |"
    puts "-".center(29, "-")
  end

  def flip
    Board.new 0, @seeds_in_houses.rotate(7)
  end

  def sow_seeds_from(house)
    detect_invalid_moves(house)
    seeds_to_sow, @seeds_in_houses[house] = @seeds_in_houses[house], 0
    last_house = sow_seeds(house - 1, seeds_to_sow - 1)
    steal_seeds(last_house)
    if houses_empty?
      :game_over
    elsif last_house == @player_store
      :again
    else
      :done
    end
  end

  def remaining_seeds
    @seeds_in_houses[4..10].inject(:+)
  end

  private

  def detect_invalid_moves(house)
    inv = "[Invalid move] - "
    raise inv << "Can't remove seeds from there" if house.zero? or house == 7
    raise inv << "Can only sow seeds from your own houses" unless @player_houses.include? house
    raise inv << "No seeds remaining in that house" if @seeds_in_houses[house].zero?
  end

  def steal_seeds(last_house)
    if @seeds_in_houses[last_house] == 1 && @player_houses.include?(last_house)
      @seeds_in_houses[@player_store] += 1 + seeds_in_opposite_house_of(last_house)
      @seeds_in_houses[last_house] = 0
    end
  end

  def seeds_in_opposite_house_of(house)
    opposites = [7, 6, 5, 4, 3, 2, 1, 0, 13, 12, 11, 10, 9, 8]
    seeds, @seeds_in_houses[opposites[house]] = @seeds_in_houses[opposites[house]], 0
    seeds
  end

  def houses_empty?
    @player_houses.all? { |house| @seeds_in_houses[house].zero? }
  end

  def sow_seeds(house, seeds)
    if house == 0
      sow_seeds(13, seeds)
    else
      @seeds_in_houses[house] += 1
      if seeds.zero?
        return house
      else
        sow_seeds(house - 1, seeds - 1)
      end
    end
  end
end
