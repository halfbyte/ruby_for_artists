module Halfbyte
  class PixelGround
    def self.dialog
      labels = ['Width', 'Length', 'Deviation', 'Cube width']
      defaults = [20, 7, 0.5, 5]
      width, length, dev, cube_size = UI.inputbox labels, defaults, "Pixel Text"
      new(width, length, dev, cube_size).place_component
    end


    def initialize(width, length, dev, cube_size=5)
      @definition = Sketchup.active_model.definitions.add "Pixel Text"
      @cube_size = cube_size
      width.times do |x|
        length.times do |y|
          z = dev * rand()
          offset = Geom::Point3d.new(x * @cube_size.mm, y * @cube_size.mm, z * @cube_size.mm)
          add_cube(offset)
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
  UI.menu("Plug-Ins").add_item("Pixelground") do
    Halfbyte::PixelGround.dialog
  end
end
file_loaded File.basename(__FILE__)
