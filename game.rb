require 'rubygems' rescue nil

require 'chingu'
include Gosu
include Chingu

require_relative 'actor_seeker'
require_relative 'actor_fleer'
require_relative 'player'

COLORS = {:red => Color.new(0xffff0000),
          :white => Color.new(0xffffffff),
          :blue => Color.new(0xff0000ff),
          :green => Color.new(0xffff6600),
          :orange => Color.new(0xff0033ff)
}

DEBUG = true

class Game < Chingu::Window
  def initialize
    super(800,600)
    self.input = {:esc => :exit}

    self.factor = 1
    5.times { ActorSeeker.create(:x => width/(rand * 10), :y => height/(rand * 10)) }
    5.times { ActorFleer.create(:x => width/(rand * 10), :y => height/(rand * 10)) }
    1.times { Player.create(:x => width/3, :y => height/3) }

    ActorFleer.all.each do |e|
      puts "w: #{e}"
      puts "#{e.steering.active_behaviors}"
    end
    ActorSeeker.all.each do |e|
      puts "S: #{e}"
      puts "#{e.steering.active_behaviors}"
    end
  end

  def update
    super
    self.caption = "Game Experiment - FPS: #{fps}, Objects: #{game_objects.size}"

    ActorFleer.each_collision(ActorFleer, Player) do |m, o|
      m.color = COLORS[:red]
      m.bonk
    end
    ActorSeeker.each_collision(ActorSeeker, Player) do |m, o|
      m.color = COLORS[:red]
      m.bonk
    end
  end
end



Game.new.show