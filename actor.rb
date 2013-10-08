require 'gosu'
require 'securerandom'

require_relative 'lib/vector2d'
require_relative 'lib/behaviors'

class Actor < GameObject
  attr_reader :id
  attr_reader :steering   # for debugging

  trait :bounding_box
  traits :velocity, :collision_detection

  # Simple data points
  attr_accessor :heading, :speed
  # Limits
  attr_accessor :max_speed

  def setup
    @id = SecureRandom.uuid

    @image = Image["Starfighter.bmp"]
    @ouched = false

    self.factor = 0.4
    self.rotation_center = :center

    @heading = Vector2d.new(0,0)
    @speed = 0
    @mass = 10

    @max_speed = 1
    @max_force = 5
    @max_turn_rate = 1

    @steering = Behaviors.new(self)

    cache_bounding_box
  end

  def position
    Vector2d.new(self.x, self.y)
  end

  def velocity
    Vector2d.new(self.velocity_x, self.velocity_y)
  end

  def update
    elapsed_ms = ms_since_last_update
    adjust_velocity_and_heading elapsed_ms

    #list_nearby_npcs
    manage_collision_highlight
  end

  def ms_since_last_update
    current_time_in_ms = Gosu::milliseconds
    ms_since_last_update = current_time_in_ms - (@last_time || 0)
    @last_time = current_time_in_ms

    ms_since_last_update / 4
  end

  def adjust_velocity_and_heading(elapsed_ms)
    acceleration = @steering.force / @mass
    acceleration.truncate!(@max_force)

    rads = Math::PI / 180

    new_velocity = self.velocity + acceleration * elapsed_ms
    angle = Vector2d.angle(@heading, new_velocity) * rads
    max_angle = @max_turn_rate * rads * elapsed_ms

    if angle.abs > max_angle
      sign = Vector2d.sign(@heading, new_velocity)
      corrected_angle = @heading.radians + max_angle * sign

      vlen = new_velocity.length
      new_velocity.x = Math.sin(corrected_angle) * vlen
      new_velocity.y = - Math.cos(corrected_angle) * vlen
    end

    new_velocity.truncate!(@max_speed)
    new_position = self.position + new_velocity * elapsed_ms

    if new_velocity.length_sq > 0.0001
      @heading = new_velocity.normalize
    end

    self.x = new_position.x
    self.y = new_position.y
    self.velocity_x = new_velocity.x
    self.velocity_y = new_velocity.y
    self.angle = @heading.angle
  end

  def manage_collision_highlight
    @ouched = false if @ouched == true

    if @ouched
      self.color = Gosu::Color::RED
    else
      self.color = Gosu::Color::WHITE
    end
  end

  def bonk
    @ouched = true
  end

  def random_x
    (rand($window.width-100))+50
  end
  def random_y
    (rand($window.height-100))+50
  end
end
