require 'rubygems' rescue nil

require 'chingu'
include Gosu
include Chingu

require_relative 'actor_pathfollower'
require_relative 'actor_flock'
require_relative 'player'

DEBUG = true

class GameFlock < Chingu::Window
  def initialize
    super(800,600)
    self.input = {:esc => :exit, :backspace => :print_status}

    self.factor = 1
    @player = Player.create(:x => random_x, :y => random_y)

#    @t = ActorSeeker.all[0]
#    2.times { ActorFollower.create(:x => random_x, :y => random_y, :leader => @t) }

#    ActorPathFollower.create(:x => random_x, :y => random_y)
    20.times { ActorFlock.create(:x => random_x, :y => random_y) }
    ActorFlock.all.each { |a| a.join_flock(ActorFlock.all) }

    puts "p: #{Player.all[0]}"

    print_status
  end

  def print_status
    game_objects.of_class(Actor).each do |a|
      puts a
      puts "  #{a.steering.active_behaviors}"
      puts "  #{a.steering.active_behaviors[:flock].length}"
    end
  end

  def random_x
    (rand*(self.width-200))+100
  end
  def random_y
    (rand*(self.height-200))+100
  end

  def update
    super
    self.caption = "Game Experiment - FPS: #{fps}, Objects: #{game_objects.size}"

    [ActorPathFollower, ActorFlock].each_collision(ActorPathFollower, ActorFlock)  { |a1, a2| collide(a1) }
#    Player.each_collision(, ActorSeeker, ActorFollower) { |p, a| destroy(a) }
  end

  def collide this_one
    this_one.color = Gosu::Color::RED
    this_one.bonk
  end

  def destroy this_one
    this_one.destroy
  end
end



GameFlock.new.show