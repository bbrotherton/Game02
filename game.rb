require 'rubygems' rescue nil

require 'chingu'
include Gosu
include Chingu

require_relative 'actor_seeker'
require_relative 'actor_fleer'
require_relative 'player'

DEBUG = false

class Game < Chingu::Window
  def initialize
    super(800,600)
    self.input = {:esc => :exit}

    self.factor = 1
    100.times { ActorSeeker.create(:x => random_x, :y => random_y) }
    #5.times { ActorFleer.create(:x => random_x, :y => random_x) }
    1.times { Player.create(:x => random_x, :y => random_x) }

    Player.all.each do |e|
      puts "p: #{e}"
    end
    ActorFleer.all.each do |e|
      puts "f: #{e}"
      puts "#{e.steering.active_behaviors}"
    end
    ActorSeeker.all.each do |e|
      puts "s: #{e}"
      puts "#{e.steering.active_behaviors}"
    end
  end

  def random_x
    (rand*(self.width-100))+50
  end
  def random_y
    (rand*(self.height-100))+50
  end

  def update
    super
    self.caption = "Game Experiment - FPS: #{fps}, Objects: #{game_objects.size}"

    Actor.each_collision(Actor, Player) do |m, o|
      collide m
    end
  end

  def collide this_one
    this_one.color = Gosu::Color::RED
    this_one.bonk
    this_one.destroy
  end
end



Game.new.show