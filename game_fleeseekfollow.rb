require 'rubygems' rescue nil

require 'chingu'
include Gosu
include Chingu

require_relative 'actor_seeker'
require_relative 'actor_fleer'
require_relative 'actor_follower'
require_relative 'actor_pathfollower'
require_relative 'player'

DEBUG = true

class GameFleeseekfollow < Chingu::Window
  def initialize
    super(800,600)
    self.input = {:esc => :exit}

    self.factor = 1
    @player = Player.create(:x => random_x, :y => random_y)

    2.times { ActorSeeker.create(:x => random_x, :y => random_y) }
    2.times { ActorFleer.create(:x => random_x, :y => random_y) }

    @t = ActorSeeker.all[0]
    2.times { @t = ActorFollower.create(:x => random_x, :y => random_y, :leader => @t) }
    ActorPathFollower.create(:x => random_x, :y => random_y)

    puts "p: #{Player.all[0]}"

    game_objects.of_class(Actor).each do |a|
      puts a
      puts "  #{a.steering.active_behaviors}"
    end
  end

  def update
    super
    self.caption = "Game Experiment - FPS: #{fps}, Objects: #{game_objects.size}"

    [ActorFleer, ActorSeeker, ActorFollower, ActorPathFollower].each_collision(ActorFleer, ActorSeeker, ActorFollower, ActorPathFollower)  { |a1, a2| collide(a1) }
    Player.each_collision(ActorFleer, ActorSeeker, ActorFollower, ActorPathFollower) { |p, a| destroy(a) }
  end

  def collide this_one
    this_one.color = Gosu::Color::RED
    this_one.bonk
  end

  def destroy this_one
    this_one.destroy
  end

  def random_x
    (rand(self.width-200))+100
  end

  def random_y
    (rand(self.height-200))+100
  end
end



GameFleeseekfollow.new.show