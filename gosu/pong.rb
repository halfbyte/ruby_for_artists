require 'gosu'

class Ball
  BORDER = 15 + 5
  attr_reader :x, :y
  def initialize(window)
    @x = 0
    @y = 0
    @vx = 0
    @vy = 0
    @window = window
  end

  def update
    @x += @vx
    @y += @vy
    check_collisions
  end

  def check_collisions
    check_vertical_collisions
    check_horizontal_collisions
  end

  def check_vertical_collisions
    if @y < BORDER || @y > (@window.height - BORDER)
      @vy *= -1.0
    end
  end

  def check_horizontal_collisions
    if @x < BORDER
      if ((100+BORDER)..(@window.height - 100+BORDER)).include?(@y)
        if !@window.player_check(0, @y)
          @window.player_loss(0)
        else
          @vx *= -1.0
        end
      else
        @vx *= -1.0
      end
    end
    if @x > (@window.width - BORDER)
      if ((100+BORDER)..(@window.height - 100+BORDER)).include?(@y)
        if !@window.player_check(1, @y)
          @window.player_loss(1)
        else
          @vx *= -1.05
          @vy *= 1.05
        end
      else
        @vx *= -1.05
        @vy *= 1.05
      end
    end
  end

  def restart(player=nil)
    player = [0,1].sample if player.nil?
    @y = 20
    @vy = 2 + rand(4.0)
    if player == 0
      @x = 20
      @vx = 2 + rand(4.0)
    elsif player == 1
      @x = @window.width - 20
      @vx = -2.0 - rand(4.0)
    end

  end

  def draw
    Gosu.draw_rect(x - 5, y - 5, 10, 10, Gosu::Color::WHITE, 1)
  end
end

class Player
  attr_reader :pos
  attr_accessor :score
  def initialize(min, max, xoff, keyboard_mapping)
    @score = 0
    @min = min
    @max = max
    @size = 50
    @pos = (@max - @min - @size) / 2 + @min
    @xoff = xoff
    @down_key = keyboard_mapping[:down]
    @up_key = keyboard_mapping[:up]
  end

  def draw
    Gosu.draw_rect(@xoff, @pos, 5, @size, Gosu::Color::WHITE, 0)
  end

  def update
    if Gosu.button_down?(@up_key)
      up
    end
    if Gosu.button_down?(@down_key)
      down
    end
  end

  def down
    @pos += 5
    if (@pos + @size) > @max
      @pos = @max - @size
    end
  end

  def up
    @pos -= 5
    if @pos < @min
      @pos = @min
    end
  end

end

class Pong < Gosu::Window

  def initialize
    super 1024, 768
    self.caption = "Ponnggggg"
    @ball = Ball.new(self)
    @ball.restart
    @players = [
      Player.new(115, height - 115, 10, {down: Gosu::KB_S, up: Gosu::KB_W}),
      Player.new(115, height - 115, width - 15, {down: Gosu::KB_DOWN, up: Gosu::KB_UP})
    ]
    @font = Gosu::Font.new(100, name: 'Futura' )
  end

  def update
    @ball.update
    @players.each(&:update)
    # @slide = Gosu::Image.from_text('Setup', 100, font: 'fonts/Coolville.ttf')
  end

  def player_check(player, y)
    pos = @players[player].pos
    if (pos <= y && y <= pos + 50)
      mid_pos = pos + 25
      return y - mid_pos
    else
      false
    end
  end

  def player_loss(player)
    winning = player == 0 ? 1 : 0
    @players[winning].score += 1
    @ball.restart winning
  end

  def draw
    draw_field
    @ball.draw
    @players.each(&:draw)
  end

  def draw_field
    Gosu.draw_rect(10, 10, width - 20, 5, Gosu::Color::WHITE, 0)
    Gosu.draw_rect(10, 15, 5, 100, Gosu::Color::WHITE, 0)
    Gosu.draw_rect(10, height - 15, width - 20, 5, Gosu::Color::WHITE, 0)
    Gosu.draw_rect(width-15, 15, 5, 100, Gosu::Color::WHITE, 0)
    Gosu.draw_rect(10, height - 115, 5, 100, Gosu::Color::WHITE, 0)
    Gosu.draw_rect(width-15, height - 115, 5, 100, Gosu::Color::WHITE, 0)

    @font.draw(@players[0].score.to_s, 100, 10, 0)
    @font.draw(@players[1].score.to_s, width - 100, 10, 0)
  end

  def button_down(id)
    if (id == Gosu::KB_DOWN)
      @players[1].down
    end
    if (id == Gosu::KB_UP)
      @players[1].up
    end
    super(id)
  end

end



Pong.new.show
