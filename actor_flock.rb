require 'gosu'
require 'securerandom'

require_relative 'lib/vector2d'
require_relative 'lib/behaviors'

require_relative 'actor'

class ActorFlock < Actor
  def setup
    super

  end

  def draw
    super

#    if @target && DEBUG
#      @crosshair ||= Gosu::Image.new($window, "media/crosshair.png", true)
#      @crosshair.draw(@target.x-7.5, @target.y-7.5, 500, 0.5, 0.5, Gosu::Color::GREEN)
#      $window.draw_line(x, y, Gosu::Color::WHITE, @target.x, @target.y, Gosu::Color::GREEN)
#    end
  end

  def update
    super

  end

  def join_flock member_array
    @steering.add_behavior(:flock, member_array)
  end
end
