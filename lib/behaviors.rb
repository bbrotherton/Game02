
POSSIBLE_BEHAVIORS = {:flee => :target_place, :avoid_edges => :none}


class Behaviors
  attr_reader :active_behaviors   # for debugging

  def initialize(actor)
    @actor = actor
    @active_behaviors = Hash.new
  end

  # Start or stop using a specific behavior
  def add_behavior(behavior, target=:none)
    @active_behaviors[behavior] = target
  end
  def remove_behavior(behavior)
    @active_behaviors.delete(behavior)
  end

  # Flee from a target location
  def velocity_change_to_flee(target_place)
    desired_velocity = (@actor.position - target_place).normalize * @actor.max_speed
    desired_velocity - @actor.velocity
  end

  # Avoid the edge of the viewport
  def velocity_change_to_avoid_edges
    @buffer = 100
    position = @actor.position

    if position.x <= 0+@buffer || position.x >= $window.width-@buffer || position.y <= 0+@buffer || position.y >= $window.height-@buffer
      x = position.x
      y = position.y

      x = 0 if position.x <= 0 + @buffer
      x = $window.width if position.x >= $window.width - @buffer
      y = 0 if position.y <= 0 + @buffer
      y = $window.height if position.y >= $window.height - @buffer

      point_along_edge = Vector2d.new(x,y)
      velocity_change_to_flee(point_along_edge)
    else
      Vector2d.new(0,0)
    end
  end


  # Calculate the steering force acting on the agent
  def force
    force = Vector2d.new(0,0)

    unless @active_behaviors[:flee].nil? && @active_behaviors[:flee]==:none
      force += velocity_change_to_flee(@active_behaviors[:flee])
    end

    unless @active_behaviors[:avoid_edges].nil?
      force += velocity_change_to_avoid_edges
    end

    force
  end
end