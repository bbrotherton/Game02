require 'gosu'
require 'securerandom'

require_relative 'lib/vector2d'
require_relative 'lib/behaviors'

require_relative 'actor'

class ActorFleer < Actor
  def setup
    super

    @steering.add_behavior(:avoid_edges)

    @target = Vector2d.new(@x+(rand*100-51),@y+(rand*100-51))
    @steering.add_behavior(:flee, @target)
  end

  def draw
    super

    if @target && DEBUG
      @crosshair ||= Gosu::Image.new($window, "media/crosshair.png", true)
      @crosshair.draw(@target.x-7.5, @target.y-7.5, 500, 0.5, 0.5, Gosu::Color::RED)
      $window.draw_line(x, y, Gosu::Color::WHITE, @target.x, @target.y, Gosu::Color::RED)
    end
  end

  def update
    super

    change_target
  end

  def change_target
    if @change_point.nil?
      @change_point = rand*60
    end
    @counter = 1 + (@counter || 1)
    if @counter >= @change_point
      @counter = 1
      @change_point = rand*60
      @target = Vector2d.new(@x+(rand*100-51),@y+(rand*100-51))
      @steering.add_behavior(:flee, @target)
    end
  end
end
