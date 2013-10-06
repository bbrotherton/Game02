class Player < GameObject
  trait :bounding_circle
  traits :velocity, :collision_detection

  def setup
    @image = Image["circle.png"]
#    self.velocity_x = rand * 5
#    self.velocity_y = rand * 5

    self.rotation_center = :center
    self.color = Gosu::Color::BLUE

    self.input = [:holding_left, :holding_right, :holding_down, :holding_up]  # NOTE: giving input an Array, not a Hash
    @ouched = false

    cache_bounding_circle
  end

  def holding_left
    @x -= 5 unless @x - 5 < 0 + (self.width / 2)
  end
  def holding_right
    @x += 5 unless @x + 5 > $window.width - (self.width / 2)
  end
  def holding_down
    @y += 5 unless @y + 5 > $window.height - (self.height / 2)
  end
  def holding_up
    @y -= 5 unless @y - 5 < 0 + (self.height / 2)
  end

  def update
    manage_collision_highlight
  end

  def manage_collision_highlight
    @ouched = false if @ouched == true

    if @ouched
      self.color = Gosu::Color::RED
    else
      self.color = Gosu::Color::BLUE
    end
  end

  def bonk
    @ouched = true
  end
end
