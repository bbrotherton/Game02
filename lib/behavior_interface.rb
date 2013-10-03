require_relative 'vector2d'

module BehaviorInterface
  # Simple data points
  attr_accessor :position, :heading, :speed
  # Complex data points
  attr_accessor :velocity
  # Limits
  attr_accessor :max_speed

  @position = Vector2d.new(0,0)
  @velocity = Vector2d.new(0,0)
  @heading = Vector2d.new(0,0)
  @speed = 0
  @max_speed = 100
end