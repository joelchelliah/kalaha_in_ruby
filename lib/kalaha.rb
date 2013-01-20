require_relative "board"
require_relative "opponents"

def menu
  puts <<-HERE
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

                                    MAIN MENU

/////////////////////////////////////////////////////////////////////////////////

  HERE
  commands
end

def commands
  puts <<-HERE
 Pick a command:

    n = New Game
    h = Help
    q = Quit

  HERE
  print "Command: "
  command = gets.chomp
  case command
  when /^(q|Q|quit|exit)$/
    exit
  when /^(n|N|New Game)$/
    play
  when /^(h|H|help|Help)$/
    help
    commands
  else
    puts "\n    What?! \n\n"
    commands
  end
end

def play
  seeds = set_num_seeds.to_i
  puts <<-HERE
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

         Starting a new game of Kalaha with #{seeds} seeds per house.

/////////////////////////////////////////////////////////////////////////////////

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

def help
  puts <<-HERE
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

                                      HELP

/////////////////////////////////////////////////////////////////////////////////

                               This is the board:

                . 1.    . 2.    . 3.        . 4.    . 5.    . 6.
   _.======================================================================._
 //         |   ----    ----    ----   ::   ----    ----    ----   |         \\\\
||          |  |    |  |    |  |    |  ::  |    |  |    |  |    |  |          ||
||   ----   |   ----    ----    ----   ::   ----    ----    ----   |   ----   ||
||  |    |  |                          ::                          |  |    |  ||
||  |    |  |                          ::                          |  |    |  ||
||  |    |  |                          ::                          |  |    |  ||
||   ----   |   ----    ----    ----   ::   ----    ----    ----   |   ----   ||
||          |  |    |  |    |  |    |  ::  |    |  |    |  |    |  |          ||
'|          |   ----    ----    ----   ::   ----    ----    ----   |          |'
  *-~======================================================================-~*
                '13'     '12'    '11'        .10.    . 9.    . 8.

/////////////////////////////////////////////////////////////////////////////////

 You control the houses on the right side     /  |          :  4  5  6 |  \\
 of the board. They are numbered:            |   |          :          | 7 |
                                              \\  |          : 10  9  8 |  /


 Your opponent controls the houses            /  | 1  2  3  :          |  \\
 on the left side of the board:              | 0 |          :          |   |
                                              \\  | 13 12 11 :          |  /

/////////////////////////////////////////////////////////////////////////////////

 Start sowing seeds from your side of the board by specifying the number of
 the house you wish to take seeds from, e.g. House: 4

 Rules on playing the game can be found here:
 http://en.wikipedia.org/wiki/Kalah#Rules

/////////////////////////////////////////////////////////////////////////////////

  HERE
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
  puts "It's your turn. Pick a house to start sowing from:"
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
    puts "You plant seeds from house #{house}:"
    board.show
    puts "Last seed landed in store. You get another turn." if result == :again
  end while result == :again
  result
end

def opponent_turn(op, board)
  begin
    board = board.flip
    house = op.pick_house_from board.seeds_in_houses
    result = board.sow_seeds_from house
    puts "Opponent plants seeds from house #{(house + 7) % 14}:"
    board = board.flip
    board.show
    puts "Last seed landed in store. Opponent gets another turn." if result == :again
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

menu