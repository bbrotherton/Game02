
POSSIBLE_BEHAVIORS = {:flee => :target_place,
                      :seek => :target_place,
                      :follow => :target_actor,
                      :avoid_edges => :none}


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

  # Seek a target location
  def velocity_change_to_seek(target_place)
    desired_velocity = (target_place - @actor.position).normalize * @actor.max_speed
    desired_velocity - @actor.velocity
  end

  # Follow a target actor
  def velocity_change_to_follow(target_actor)
    v = Vector2d.new(target_actor.x, target_actor.y)
    velocity_change_to_seek v
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

      window_center = Vector2d.new($window.width/2, $window.height/2)
      velocity_change_to_seek(window_center)
    else
      Vector2d.new(0,0)
    end
  end


  # Calculate the steering force acting on the agent
  def force
    force = Vector2d.new(0,0)

    if (not @active_behaviors[:flee].nil?) && @active_behaviors[:flee]!=:none
      force += velocity_change_to_flee(@active_behaviors[:flee])
    end

    if (not @active_behaviors[:seek].nil?) && @active_behaviors[:seek]!=:none
      force += velocity_change_to_seek(@active_behaviors[:seek])
    end

    if (not @active_behaviors[:follow].nil?) && @active_behaviors[:follow]!=:none
      force += velocity_change_to_follow(@active_behaviors[:follow])
    end

    unless @active_behaviors[:avoid_edges].nil?
      force += velocity_change_to_avoid_edges
    end

    force
  end
end