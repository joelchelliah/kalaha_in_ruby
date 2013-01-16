require "rspec"
require_relative "../lib/board"

describe "Remaining seeds" do

  it "should count the number of remaining seeds on one side of the board" do
    Board.new(4).remaining_seeds.should eq 24
    Board.new(5).remaining_seeds.should eq 30
    Board.new(6).remaining_seeds.should eq 36
  end
end

describe "Flip board" do
  let(:board) { Board.new(0, [0, 0, 0, 0, 4, 4, 4, 0, 4, 4, 4, 0, 0, 0]) }

  it "should turn the board around 180 degrees" do
    board.remaining_seeds.should eq 24
    board.flip.remaining_seeds.should eq 0

    board = Board.new(0, [0, 2, 0, 4, 0, 4, 4, 0, 4, 4, 4, 0, 0, 0])
    board.remaining_seeds.should eq 20
    board.flip.remaining_seeds.should eq 6
  end
end

describe "Sow seeds" do
  let(:board) { Board.new(0, [0, 0, 0, 0, 4, 4, 4, 0, 4, 4, 4, 0, 0, 0]) }

  it "should sow seeds from a given house in a counter-clockwise direction" do
    board.remaining_seeds.should eq 24

    board.sow_seeds_from 4
    board.remaining_seeds.should eq 24 - 4
    board.flip.remaining_seeds.should eq 4

    board.sow_seeds_from 5
    board.remaining_seeds.should eq 17
    board.flip.remaining_seeds.should eq 7
  end

  it "should steal seeds from opposing house if last seed lands in an empty house" do
    board.remaining_seeds.should eq 24

    board.sow_seeds_from 4
    board.sow_seeds_from 8
    board.remaining_seeds.should eq 24 - 4 + 1
  end

  it "should return :done after sowing seeds and there are still seeds remaining in other houses" do
    board.sow_seeds_from(4).should eq :done
  end

  it "should return :game_over if all houses are empty after sowing" do
    board.sow_seeds_from(4).should_not eq :game_over
    board.sow_seeds_from 10
    board.sow_seeds_from 9
    board.sow_seeds_from 8
    board.sow_seeds_from 6
    board.sow_seeds_from 5
    board.sow_seeds_from(4).should eq :game_over
  end

  it "should return :again if the last seed lands in the store" do
    board = Board.new(0, [0, 0, 0, 0, 4, 4, 4, 0, 1, 2, 4, 0, 0, 0])
    board.sow_seeds_from(8).should eq :again
    board.sow_seeds_from(9).should eq :again
    board.sow_seeds_from(10).should_not eq :again
  end
end