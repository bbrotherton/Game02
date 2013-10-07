require 'gosu'
require 'securerandom'

require_relative 'lib/vector2d'
require_relative 'lib/behaviors'

require_relative 'actor'

class ActorSeeker < Actor
  def setup
    super

    @steering.add_behavior(:seek, Vector2d.new(random_x,random_y))
  end

  def draw
    super

    if @target && DEBUG
      @crosshair ||= Gosu::Image.new($window, "media/crosshair.png", true)
      @crosshair.draw(@target.x-7.5, @target.y-7.5, 500, 0.5, 0.5, Gosu::Color::GREEN)
      $window.draw_line(x, y, Gosu::Color::WHITE, @target.x, @target.y, Gosu::Color::GREEN)
    end
  end

  def update
    super

    change_target
  end

  def change_target
#    @target = Vector2d.new(Player.all[0].x, Player.all[0].y)
    if @change_point.nil?
      @change_point = rand*120
    end
    @counter = 1 + (@counter || 1)
    if @counter >= @change_point
      @counter = 1
      @change_point = rand*120
      @target = Vector2d.new(random_x, random_y)
      @steering.add_behavior(:seek, @target)
    end
    @steering.add_behavior(:seek, @target)
  end

  def random_x
    (rand*($window.width-100))+50
  end
  def random_y
    (rand*($window.height-100))+50
  end
end
