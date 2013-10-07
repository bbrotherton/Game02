require 'rubygems' rescue nil

require 'chingu'
include Gosu
include Chingu

require_relative 'actor_seeker'
require_relative 'actor_follower'
require_relative 'actor_pathfollower'
require_relative 'player'

DEBUG = true

class GameFlock < Chingu::Window
  def initialize
    super(800,600)
    self.input = {:esc => :exit}

    self.factor = 1
    @player = Player.create(:x => random_x, :y => random_y)
#    1.times { ActorSeeker.create(:x => random_x, :y => random_y) }

#    @t = ActorSeeker.all[0]
#    2.times { ActorFollower.create(:x => random_x, :y => random_y, :leader => @t) }

    ActorPathFollower.create(:x => random_x, :y => random_y)

    Player.all.each do |e|
      puts "U: #{e}"
    end
    ActorSeeker.all.each do |e|
      puts "s: #{e}"
      puts "#{e.steering.active_behaviors}"
    end
    ActorFollower.all.each do |e|
      puts "F: #{e}"
      puts "#{e.steering.active_behaviors}"
    end
    ActorPathFollower.all.each do |e|
      puts "p: #{e}"
      puts "#{e.steering.active_behaviors}"
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

    [ActorSeeker, ActorFollower].each_collision(ActorSeeker, ActorFollower)  { |a1, a2| collide(a1) }
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