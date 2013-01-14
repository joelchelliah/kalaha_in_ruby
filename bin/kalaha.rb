require_relative "../lib/board.rb"
require_relative "../lib/opponents.rb"

def play
  seeds = set_num_seeds.to_i
  puts <<-HERE

/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////

Starting a new game of Kalaha with #{seeds} seeds per house.

/////////////////////////////////////////////////////////////

You control the houses on             |          :  4  5  6 |
the right side. They are numbered:    |          :          | 7
                                      |          : 10  9  8 |


Your opponent controls the houses     | 1  2  3  :          |
on the left side of the board:      0 |          :          |
                                      | 13 12 11 :          |

/////////////////////////////////////////////////////////////

  HERE
  board = Board.new(seeds)
  opponent = BasicOpponent.new
  board.show

  while true
    result = player_turn(board)

    unless result == :done
      show_score board
      break
    end

    board, result = opponent_turn(opponent, board)

    unless result == :done
      show_score board
      break
    end
  end
  replay?()
end

def set_num_seeds
  print " * Specify number of seeds per house (4-6): "
  num_seeds = gets.chomp
  if num_seeds =~ /q|quit|exit/
    exit
  elsif num_seeds =~ /4|5|6/
    num_seeds
  else
    puts "   Must pick a number between 4 and 6\n\n"
    set_num_seeds
  end
end

def player_turn(board)
  puts "\nIt's your turn. Pick a house to start from:"
  begin
    result = nil
    while result.nil?
      print "House: "
      house = gets.chomp.to_i
      begin
        result = board.sow_seeds_from house
      rescue Exception => e
        if e.message.start_with? "[Invalid move]"
          puts e.message
          puts "try again."
        else
          raise
        end
      end
    end
    puts "\nYou plant seeds from house #{house}:"
    board.show
    puts "\nLast seed landed in store. You get another turn." if result == :again
  end while result == :again
  result
end

def opponent_turn(op, board)
  begin
    board = board.flip
    house = op.pick_house_from board.seeds_in_houses
    result = board.sow_seeds_from house
    puts "\nOpponent plants seeds from house #{(house + 7) % 14}:"
    board = board.flip
    board.show
    puts "\nLast seed landed in store. Opponent gets another turn." if result == :again
  end while result == :again
  return board, result
end

def show_score(board)
  your_score = board.remaining_seeds
  opponent_score = board.flip.remaining_seeds
  puts <<-HERE

    Game over. #{(your_score > opponent_score ? "You won!" : "You lost.")}
    Final score: #{your_score} - #{opponent_score}

  HERE
end

def replay?
  print "Play again? (y/n): "
  if gets.chomp =~ /y|Y|yes|YES|yup|ok/ then
    play
  else
    exit
  end
end

play