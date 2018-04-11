require_relative 'mittsu_patch'
require 'mittsu'


require_relative '../char_font'

def draw_character(char_data, xoff)
  cubes = []
  geometry = Mittsu::BoxGeometry.new(1.0, 1.0, 1.0)
  material = Mittsu::MeshLambertMaterial.new(color: 0x880000)
  char_data[:data].each_with_index do |bits, y|
    0.upto(char_data[:width]) do |x|
      if (bits & (1 << x) > 0)
        cube = Mittsu::Mesh.new(geometry, material)
        cube.position.x = (xoff + x) * 1.1
        cube.position.y = (5-y) * 1.1
        cubes << cube
      end
    end
  end
  cubes
end

SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
ASPECT = SCREEN_WIDTH.to_f / SCREEN_HEIGHT.to_f

scene = Mittsu::Scene.new
camera = Mittsu::PerspectiveCamera.new(75.0, ASPECT, 1, 1000.0)

renderer = Mittsu::OpenGLRenderer.new width: SCREEN_WIDTH, height: SCREEN_HEIGHT, title: '02 Box Mesh Example'

ambient_light = Mittsu::AmbientLight.new( 0x404040 );
point_light = Mittsu::PointLight.new(0xffff00)
point_light.position.z = 2
point_light.position.y = -2
scene.add(ambient_light)
scene.add(point_light)


group = Mittsu::Group.new()
text = "i § ruby"
xoff = 0
text.each_char do |c|
  char_data = CharFont::CHARS[c]
  cubes = draw_character(char_data, xoff)
  group.add(*cubes) unless cubes.empty?
  xoff += char_data[:width]
end
group.position.x = -(xoff / 2)
outer_group = Mittsu::Group.new
outer_group.add(group)
outer_group.position.z = -30

scene.add(outer_group)
camera.position.z = 5.0

renderer.window.on_resize do |width, height|
  renderer.set_viewport(0, 0, width, height)
  camera.aspect = width.to_f / height.to_f
  camera.update_projection_matrix
end

renderer.window.run do
  outer_group.rotation.x += 0.05
  outer_group.rotation.y += 0.05

  renderer.render(scene, camera)
end
