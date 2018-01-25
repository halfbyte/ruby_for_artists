require 'mittsu'

SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
ASPECT = SCREEN_WIDTH.to_f / SCREEN_HEIGHT.to_f

scene = Mittsu::Scene.new
camera = Mittsu::PerspectiveCamera.new(75.0, ASPECT, 0.1, 1000.0)

renderer = Mittsu::OpenGLRenderer.new width: SCREEN_WIDTH, height: SCREEN_HEIGHT, title: '04 Spot Light Example'

box_geometry = Mittsu::BoxGeometry.new(1.0, 1.0, 1.0)
sphere_geometry = Mittsu::SphereGeometry.new(1.0)
floor_geometry = Mittsu::BoxGeometry.new(20.0, 0.1, 20.0, 20, 1, 20)
green_material = Mittsu::MeshLambertMaterial.new(color: 0x00ff00)
blue_material = Mittsu::MeshLambertMaterial.new(color: 0x0000ff)
sphere = Mittsu::Mesh.new(sphere_geometry, blue_material)
floor = Mittsu::Mesh.new(floor_geometry, green_material)
floor.position.set(0.0, -2.0, 0.0)
scene.add(sphere)
scene.add(floor)

room_material = Mittsu::MeshPhongMaterial.new(color: 0xffffff)
room_material.side = Mittsu::BackSide
room = Mittsu::Mesh.new(box_geometry, room_material)
room.scale.set(10.0, 10.0, 10.0)
scene.add(room)

light = Mittsu::SpotLight.new(0xffffff, 1.0, 10.0)
light.position.set(3.0, 1.0, 0.0)
dot = Mittsu::Mesh.new(box_geometry, Mittsu::MeshBasicMaterial.new(color: 0xffffff))
dot.scale.set(0.1, 0.1, 0.1)
light.add(dot)
light_object = Mittsu::Object3D.new
light_object.add(light)
scene.add(light_object)

camera.position.z = 5.0

renderer.window.on_resize do |width, height|
  renderer.set_viewport(0, 0, width, height)
  camera.aspect = width.to_f / height.to_f
  camera.update_projection_matrix
end

renderer.window.run do
  light_object.rotation.y += 0.1

  renderer.render(scene, camera)
end
