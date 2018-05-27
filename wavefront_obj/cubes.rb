require 'wavefront_obj'
require_relative '../char_font'

def make_cube(obj, pos, size)
  x, y, z = pos
  if size.is_a?(Array)
    xs, ys, zs = size
  else
    xs, ys, zs = [size, size, size]
  end
  obj.add_face [[x + xs, y, z],[x + xs, y, z + zs],[x, y, z + zs],[x, y, z]]
  obj.add_face [[x + xs, y + ys, z],[x, y + ys, z],[x, y + ys, z + zs],[x + xs, y + ys, z + zs]]
  obj.add_face [[x + xs, y, z],[x + xs, y + ys, z],[x + xs, y + ys, z + zs],[x + xs,y , z + zs]]
  obj.add_face [[x + xs, y, z + zs],[x + xs, y + ys, z + zs],[x, y + ys, z + zs],[x, y, z + zs]]
  obj.add_face [[x, y, z + zs],[x, y + ys, z + zs],[x, y + ys, z],[x, y, z]]
  obj.add_face [[x + xs, y + ys, z],[x + xs, y, z],[x, y, z],[x, y + ys, z]]
end

def draw_character(obj, char_data, xoff)
  char_data[:data].each_with_index do |bits, y|
    0.upto(char_data[:width]) do |x|

      if (bits & (1 << x) > 0)
        make_cube(obj, [xoff + x, 5-y, 0.8], [1, 1, 1.2])
      end
    end
  end
end

cubes = WavefrontObj.new
cubes.name = "lotsa cubes"
xoff = 1
text = "balkan § ruby"

text.each_char do |c|
  char_data = CharFont::CHARS[c]
  draw_character(cubes, char_data, xoff)
  xoff += char_data[:width]
end

# Build random ground
(xoff + 1).times do |x|
  7.times do |y|
    make_cube(cubes, [x,y,0], [1, 1, 0.8 + (rand() * 0.4)])
  end
end
cubes.save "cubes.obj"
