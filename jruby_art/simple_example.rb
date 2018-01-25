# converted from "Generative Design" example P_2_1_1_01
# http://www.generative-gestaltung.de/P_2_1_1_01
# run with: k9 --run simple_example.rb
def settings
  size 400, 400
end

TILE_COUNT = 20
attr_reader :act_stroke_cap, :act_random_seed

def setup
  sketch_title 'P_2_1_1_01'
  @act_stroke_cap = SQUARE
  @act_random_seed = 0
end

def draw
  background 255
  smooth
  no_fill
  random_seed act_random_seed
  stroke_cap act_stroke_cap

  (0..TILE_COUNT).each do |grid_y|
    (0..TILE_COUNT).each do |grid_x|
      pos_x = width / TILE_COUNT * grid_x
      pos_y = width / TILE_COUNT * grid_y
      toggle = random(0,2).to_i
      if toggle == 0
        stroke_weight(mouse_x / 20)
        line(pos_x, pos_y, pos_x + width / TILE_COUNT, pos_y + height / TILE_COUNT)
      elsif toggle == 1
        stroke_weight(mouse_y / 20)
        line(pos_x, pos_y + height / TILE_COUNT, pos_x + width / TILE_COUNT, pos_y)
      end
    end
  end
end

def mouse_pressed
  @act_random_seed = random(100000).to_i
end

def key_pressed
  if key == '1'
    @act_stroke_cap = ROUND
  elsif key == '2'
    @act_stroke_cap = SQUARE
  elsif key == '3'
    @act_stroke_cap = PROJECT
  end
end
