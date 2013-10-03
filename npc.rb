# Add our lib directory to the load path
lib_dir = File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
$LOAD_PATH.unshift(lib_dir)

require 'gosu'
require 'securerandom'

require 'vector2d'
require 'behaviors'
require 'behavior_interface'

class Npc < GameObject
  include BehaviorInterface

  attr_reader :id

  trait :bounding_box
  traits :velocity, :collision_detection


  # Simple data points
  attr_accessor :position, :heading, :speed
  # Complex data points
  attr_accessor :velocity
  # Limits
  attr_accessor :max_speed

  def setup
    @id = SecureRandom.uuid

    @red = Color.new(0xffff0000)
    @white = Color.new(0xffffffff)

    @image = Image["Starfighter.bmp"]
    @ouched = false

    self.factor = 0.5
    self.rotation_center = :center

    @position = Vector2d.new(0,0)
    @heading = Vector2d.new(0,0)
    @speed = 0
    @mass = 10

    @velocity = Vector2d.new(0,0)

    @max_speed = 1
    @max_force = 50
    @max_turn_rate = 60

    @steering = Behaviors.new(self)
    @steering.add_behavior(:flee, Vector2d.new(@x,@y))

    cache_bounding_box
  end

  def update
    current_time_in_ms = Gosu::milliseconds
    ms_since_last_update = current_time_in_ms - (@last_time || 0)
    @last_time = current_time_in_ms

    acceleration = @steering.force / @mass
    acceleration.truncate!(@max_force)

    rads = Math::PI / 180
    new_velocity = @velocity + acceleration * ms_since_last_update
    @angle = Vector2d.angle(@heading, new_velocity) * rads
    max_angle = @max_turn_rate * rads * ms_since_last_update

    if @angle.abs > max_angle
      sign = Vector2d.sign(@heading, new_velocity)
      corrected_angle = @heading.radians + max_angle * sign
      @velocity.x = Math.sin(corrected_angle) * new_velocity.length
      @velocity.y = - Math.cos(corrected_angle) * new_velocity.length
    else
      @velocity = new_velocity
    end

    @velocity.truncate!(@max_speed)
    @position += @velocity * ms_since_last_update

    if @velocity.length_sq > 0.0001
      @heading = @velocity.normalize
    end

    #list_nearby_npcs
    manage_collision_highlight

    self.velocity_x = @velocity.x
    self.velocity_y = @velocity.y
    self.angle = @heading.angle
  end

  def manage_collision_highlight
    @ouched = false if @ouched == true

    if @ouched
      self.color = @red
    else
      self.color = @white
    end
  end

  def list_nearby_npcs
    arr = []
    Npc.all.each do |e|
      if in_circle(self.x, self.y, 2*width, e.x, e.y) && e != self
        arr << e
      end
    end
    puts "#{self.id} - #{arr}"
  end

  def bonk
    @ouched = true
  end

  def in_circle(center_x, center_y, radius, x, y)
    square_dist = (center_x - x) ** 2 + (center_y - y) ** 2
    square_dist <= radius ** 2
  end
end
