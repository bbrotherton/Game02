
POSSIBLE_BEHAVIORS = {:flee => :target_point,
                      :seek => :target_point,
                      :follow => :target_actor,
                      :follow_path => :waypoint_array,
                      :flock => :array_of_members,
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
  def velocity_change_to_flee(target_point)
    desired_velocity = (@actor.position - target_point).normalize * @actor.max_speed
    desired_velocity - @actor.velocity
  end

  # Seek a target location
  def velocity_change_to_seek(target_point)
    desired_velocity = (target_point - @actor.position).normalize * @actor.max_speed
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
      velocity_change_to_seek window_center
    else
      Vector2d.new(0,0)
    end
  end

  # Go to the next waypoint
  def velocity_change_to_waypoint(waypoint_array)
    if waypoint_array.nil? || waypoint_array.length < 1
      Vector2d.new(0,0)
    else
      @index ||= 0

      if (@actor.position - waypoint_array[@index]).length.abs <= (@actor.height+@actor.width)
        @index += 1
        @index = 0 if @index >= waypoint_array.length
      end

        velocity_change_to_seek waypoint_array[@index]
    end
  end

  # Stay with the flock
  def velocity_change_to_flock(array_of_members)
    separation_vector = Vector2d.new(0,0)
    array_of_members.each do |e|
      if e != @actor && in_sight(3*@actor.width, e)
        if too_close? e
          separation_vector += velocity_change_to_flee(e.position)
        end
      end
    end

    if separation_vector == Vector2d.new(0,0)
      velocity_change_to_seek(Vector2d.new(rand(400), rand(400)))
    else
      separation_vector
    end
  end

  def in_sight(radius, other)
    if (@actor.position - other.position).length.abs > radius
      return false # far enough away
    end

    direction = @actor.velocity.normalize
    difference = other.position - @actor.position
    dot_prod = difference.dot(direction)

    dot_prod >= 0
  end

  def too_close? other
    (@actor.position - other.position).length.abs <= (@actor.width + other.width) * 1.5
  end


  # Calculate the steering force acting on the agent
  def force
    force = Vector2d.new(0,0)

    if (not @active_behaviors[:follow_path].nil?) && @active_behaviors[:follow_path]!=:none
      force += velocity_change_to_waypoint(@active_behaviors[:follow_path])
    end

    if (not @active_behaviors[:flee].nil?) && @active_behaviors[:flee]!=:none
      force += velocity_change_to_flee(@active_behaviors[:flee])
    end

    if (not @active_behaviors[:seek].nil?) && @active_behaviors[:seek]!=:none
      force += velocity_change_to_seek(@active_behaviors[:seek])
    end

    if (not @active_behaviors[:follow].nil?) && @active_behaviors[:follow]!=:none
      force += velocity_change_to_follow(@active_behaviors[:follow])
    end

    unless @active_behaviors[:flock].nil? && @active_behaviors[:flock]!=:none
      force += velocity_change_to_flock(@active_behaviors[:flock])
    end

    unless @active_behaviors[:avoid_edges].nil?
      force += velocity_change_to_avoid_edges
    end

    force
  end
end