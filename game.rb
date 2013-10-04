require 'rubygems' rescue nil

require 'chingu'
include Gosu
include Chingu

require_relative 'npc'
require_relative 'player'

class Game < Chingu::Window
  @debug = true
  class << self
    attr_accessor :debug
  end


  def initialize
    super(800,600)
    self.input = {:esc => :exit}

    @red = Color.new(0xFFFF0000)
    @white = Color.new(0xFFFFFFFF)
    @blue = Color.new(0xFF0000FF)

    self.factor = 1
    25.times { Npc.create(:x => width/(rand * 10), :y => height/(rand * 10)) }
    1.times { Player.create(:x => width/3, :y => height/3) }

    Npc.all.each do |e|
      puts "e: #{e}"
      puts "#{e.steering.active_behaviors}"
    end
  end

  def update
    super
    self.caption = "Game Experiment - FPS: #{fps}, Objects: #{game_objects.size}"

    Npc.each_collision(Npc, Player) do |m, o|
      m.color = @red
      m.bonk
    end
  end
end



Game.new.show