require 'gosu'
require 'securerandom'

require_relative 'lib/vector2d'
require_relative 'lib/behaviors'

require_relative 'actor'

class ActorPathFollower < Actor
  def setup
    super

    waypoints = []
    waypoints << Vector2d.new($window.width/2, $window.height/2)
    waypoints << Vector2d.new(100, 100)
    waypoints << Vector2d.new($window.width-100, 100)
    waypoints << Vector2d.new($window.width/2, $window.height/2)
    waypoints << Vector2d.new($window.width-100, $window.height-100)
    waypoints << Vector2d.new(100, $window.height-100)

    @steering.add_behavior(:follow_path, waypoints)
  end

  def draw
    super

    if @steering.active_behaviors[:follow_path] && DEBUG
      @crosshair ||= Gosu::Image.new($window, "media/crosshair.png", true)
      arr = @steering.active_behaviors[:follow_path]

      arr.each { |wp| @crosshair.draw(wp.x-7.5, wp.y-7.5, 0, 0.5, 0.5, Gosu::Color::YELLOW) }
    end
  end

  def current_path
    @steering.active_behaviors[:follow_path]
  end

  def change_path (wp_array)
    @steering.add_behavior(:follow_path, wp_array)
  end
end
