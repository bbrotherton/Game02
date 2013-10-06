require 'gosu'
require 'securerandom'

require_relative 'lib/vector2d'
require_relative 'lib/behaviors'

require_relative 'actor'

class ActorFollower < Actor
  def setup
    super
    @max_speed = 0.8
  end

  def initialize (*options,&block)
    super(*options,&block)
    set_leader options[0][:leader]
  end

  def draw
    super

    if @target && DEBUG
      $window.draw_line(x, y, Gosu::Color::WHITE, @target.x, @target.y, Gosu::Color::GREEN)
    end
  end

  def set_leader (leader)
    @target = leader
    @steering.add_behavior(:follow, leader)
  end
end
