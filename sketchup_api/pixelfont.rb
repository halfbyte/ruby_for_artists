require 'sketchup'

require_relative '../char_font'

module Halfbyte
  class Pixelfont
    def self.dialog
      labels = ['Text', 'Cube width']
      defaults = ['hello', 5]
      text, cube_size = UI.inputbox labels, defaults, "Pixel Text"
      new(text, cube_size).place_component
    end


    def initialize(text, cube_size=5)
      @definition = Sketchup.active_model.definitions.add "Pixel Text"
      @cube_size = cube_size
      text = text.downcase
      xoff = 0
      text.each_char do |c|
        char_data = CHARS[c]
        draw_character(char_data, xoff)
        xoff += char_data[:width]
      end
    end

    def draw_character(char_data, xoff)
      char_data[:data].each_with_index do |bits, y|
        puts bits.to_s(2)
        0.upto(char_data[:width]) do |x|

          if (bits & (1 << x) > 0)
            off = Geom::Point3d.new((xoff + x) * @cube_size.mm, (5-y) * @cube_size.mm)
            add_cube(off)
          end
        end
      end
    end


    def add_cube(offset = Geom::Point3d.new(0,0,0))
      puts "cube at #{offset.inspect}"
      size = @cube_size
      group = @definition.entities.add_group
      points = [Geom::Point3d.new(0, 0, 0), Geom::Point3d.new(size.mm, 0, 0), Geom::Point3d.new(size.mm, size.mm, 0), Geom::Point3d.new(0, size.mm, 0)]
      face = group.entities.add_face(points)
      face.pushpull(-size.mm)
      group.move!(offset)
    end

    def place_component
      Sketchup.active_model.place_component @definition
    end
  end
end

unless file_loaded? File.basename(__FILE__)
  UI.menu("Plug-Ins").add_item("Pixeltext") do
    Halfbyte::Pixelfont.dialog
  end
end
file_loaded File.basename(__FILE__)
