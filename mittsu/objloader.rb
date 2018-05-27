require_relative 'mittsu_patch'
require 'mittsu'

require_relative '../char_font'



SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
ASPECT = SCREEN_WIDTH.to_f / SCREEN_HEIGHT.to_f

def draw_character(char_data, xoff)
  cubes = []
  geometry = Mittsu::BoxGeometry.new(1.0, 1.0, 1.0)
  material = Mittsu::MeshLambertMaterial.new(color: 0x8888FF)
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


scene = Mittsu::Scene.new
camera = Mittsu::PerspectiveCamera.new(75.0, ASPECT, 0.1, 1000.0)

renderer = Mittsu::OpenGLRenderer.new width: SCREEN_WIDTH, height: SCREEN_HEIGHT, title: '02 Box Mesh Example'

loader = Mittsu::OBJMTLLoader.new

ambient_light = Mittsu::AmbientLight.new( 0x404040 );
point_light = Mittsu::PointLight.new(0xff0000)
point_light.position.z = 2
point_light.position.y = -2
scene.add(ambient_light)
scene.add(point_light)


thing = loader.load('Ruby_Normalized.obj', 'Ruby_Normalized.mtl')
RUBY_SCALE = 0.5
thing.scale.x = RUBY_SCALE
thing.scale.y = RUBY_SCALE
thing.scale.z = RUBY_SCALE

group = Mittsu::Group.new

MATRIX_SIZE = 8

MATRIX_SIZE.times do |y|
  MATRIX_SIZE.times do |x|
    new_thing = thing.clone()
    new_thing.position.y = (-(MATRIX_SIZE / 2) + y) * 30
    new_thing.position.x = (-(MATRIX_SIZE / 2) + x) * 30
    group.add(new_thing)
  end
end
group.position.x = 10
group.position.z = -100
scene.add(group)

text_group = Mittsu::Group.new()
text = "balkan § ruby"
xoff = 0
text.each_char do |c|
  char_data = CharFont::CHARS[c]
  cubes = draw_character(char_data, xoff)
  text_group.add(*cubes) unless cubes.empty?
  xoff += char_data[:width]
end
text_group.position.x = -(xoff / 2)
outer_group = Mittsu::Group.new
outer_group.add(text_group)
outer_group.position.z = -30

scene.add(outer_group)

camera.position.z = 5.0

renderer.window.on_resize do |width, height|
  renderer.set_viewport(0, 0, width, height)
  camera.aspect = width.to_f / height.to_f
  camera.update_projection_matrix
end

framecount = 0
renderer.window.run do
  group.position.z = - 100 + Math.sin(framecount.to_f / 100.0) * 20
  group.children.each do |child|
    child.rotation.x += 0.1
    child.rotation.z += 0.1
  end
  outer_group.rotation.x = Math.sin(framecount.to_f / 200.0)
  outer_group.rotation.y = Math.cos(framecount.to_f / 50.0)

  dingcount = 0
  outer_group.traverse do |ding|
    if ding.type == 'Mesh'
      ding.position.z = Math.sin((framecount.to_f + dingcount.to_f) / 20) * 2
      dingcount += 1
    end
  end

  renderer.render(scene, camera)
  framecount+= 1
end
