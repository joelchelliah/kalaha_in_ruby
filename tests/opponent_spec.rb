require "rspec"
require_relative "../lib/opponents"

describe "Basic opponent" do
  let(:opponent) { BasicOpponent.new }

  it "should find all houses that still contain seeds" do
    opponent.get_nonempty_houses([0, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4]).should == []
    opponent.get_nonempty_houses([0, 4, 4, 4, 0, 5, 5, 0, 0, 5, 0, 4, 4, 4]).should == [5, 6, 9]
    opponent.get_nonempty_houses([0, 4, 4, 4, 5, 5, 5, 0, 5, 5, 5, 4, 4, 4]).should == [4, 5, 6, 8, 9, 10]

  end

  it "should pick a random non-empty house" do
    opponent.pick_house_from([0, 4, 4, 4, 0, 5, 5, 0, 5, 5, 5, 4, 4, 4]).should_not == 4
    opponent.pick_house_from([0, 4, 4, 4, 5, 0, 5, 0, 5, 5, 5, 4, 4, 4]).should_not == 5
    opponent.pick_house_from([0, 4, 4, 4, 5, 5, 0, 0, 5, 5, 5, 4, 4, 4]).should_not == 6
    opponent.pick_house_from([0, 4, 4, 4, 5, 5, 5, 0, 0, 5, 5, 4, 4, 4]).should_not == 8
    opponent.pick_house_from([0, 4, 4, 4, 5, 5, 5, 0, 5, 0, 5, 4, 4, 4]).should_not == 9
    opponent.pick_house_from([0, 4, 4, 4, 5, 5, 5, 0, 5, 5, 0, 4, 4, 4]).should_not == 10
  end
end

describe "Greedy opponent" do
  let(:opponent) { GreedyOpponent.new }

  it "should pick the house that increases the store pile the most" do
    opponent.pick_house_from([0,4,4,4,4,4,4,0,4,0,0,4,4,4]).should == 8
    opponent.pick_house_from([0,4,4,4,4,4,4,0,0,4,0,4,4,4]).should == 9
  end

  it "should pick the house that plants the least seeds in opponent areas" do
    opponent.pick_house_from([0,4,4,4,4,4,2,0,0,0,0,4,4,4]).should == 6
    opponent.pick_house_from([0,4,4,4,1,1,3,0,0,0,0,4,4,4]).should == 5
  end

  it "should pick the house that steals the most seeds from the opponent" do
    opponent.pick_house_from([0,4,4,4,0,4,4,0,4,4,4,4,4,4]).should == 8
    opponent.pick_house_from([0,4,4,4,7,9,4,0,4,0,0,11,12,4]).should == 5
  end

  it "should value the house that gives it a second turn slightly higher than a regular house" do

  end
end
