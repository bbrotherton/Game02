require 'gosu'
require 'securerandom'

require_relative 'lib/vector2d'
require_relative 'lib/behaviors'

require_relative 'actor'

class ActorFlock < Actor
  def setup
    super

    members = self.options[:members]
    @steering.add_behavior(:flock, members)
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

  def random_x
    (rand*($window.width-100))+50
  end
  def random_y
    (rand*($window.height-100))+50
  end

  def list_nearby_npcs
    arr = []
    ActorFleer.all.each do |e|
      if in_circle(self.x, self.y, 2*width, e.x, e.y) && e != self
        arr << e
      end
    end
    puts "#{self.id} - #{arr}"
  end

  def in_circle(center_x, center_y, radius, x, y)
    square_dist = (center_x - x) ** 2 + (center_y - y) ** 2
    square_dist <= radius ** 2
  end
end
