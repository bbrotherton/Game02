
POSSIBLE_BEHAVIORS = {:flee => :target_place}


class Behaviors

  def initialize actor
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
  def velocity_change_for_fleeing(target_place)
    desired_velocity = (@actor.position - target_place).normalize * @actor.max_speed
    desired_velocity - @actor.velocity
  end

  # Calculate the steering force acting on the agent
  def force
    force = Vector2d.new(0,0)

    unless @active_behaviors[:flee].nil? || @active_behaviors[:flee]==:none
      force += velocity_change_for_fleeing(@active_behaviors[:flee])
    end

    force
  end
end