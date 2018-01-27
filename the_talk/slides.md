class: center, middle

# My Ruby Is a Paintbrush
# My Ruby Is a Synth
## Jan 'half/byte' Krutisch
## @halfbyte

---
class: center, middle, depfu, contain
background-image: url(images/depfu-left-blue.png)
---
class: center, middle, depfu
# A warning
---
### Don't try to understand the code examples!

Note: This not meant as an insult. I'm just aware that it's a lot of code on very different subjects and it will be next to impossible to understand it during the presentation. Instead, go to [halfbyte/ruby_for_artists](https://github.com/ruby_for_artists) and study the examples there.

I'm providing the code fragments here to give you a sense of how much (or rather: how little) code is necessary and how the code looks in general. More of a teaser or taste bite than actually explaining how a library works.

The reason I have (in contrast to what every one tells you to do) a looong text on one slide is that I want to warn people who click through these slides later on.

(If you're sitting in the audience and you made it this far, please clap your hands twice.)
---
class: center, middle, depfu

# 2D

---
class: center, middle

# offline

---

# [halfbyte/calgen](https://github.com/halfbyte/calgen)

---

class: contain, bottom
background-image: url(images/real_calendar.jpeg)
[IBA Hamburg: BIQ](https://www.iba-hamburg.de/projekte/bauausstellung-in-der-bauausstellung/smart-material-houses/biq/projekt/biq.html)
---
class: contain
background-image: url(images/calendar_januar.png)
---
# gem install 'prawn'
---

```ruby
pdf = Prawn::Document.new(
  page_size: 'A4',
  bottom_margin: EXTRA_MARGIN_VERTICAL
)

# [...]

DAYS.each_with_index do |day, i|
  pdf.bounding_box(
    [i * col_width + box_offset, pdf.bounds.height],
    :width => max_text_width, height: row_height
  ) do
    pdf.fill_color = color(i > 4)
    pdf.text(day, align: :right, valign: :center)
  end
end

# [...]

pdf.render_file(options[:outfile])
```
---

# realtime
---
class: contain
background-image: url(images/generative_design_09.png)

---
class: center, middle
# processing

---
class: center, middle
# Java?!?

---
class: center, middle
# JRuby_Art

---

```ruby
def settings
  size 400, 400
end

TILE_COUNT = 20
attr_reader :act_stroke_cap, :act_random_seed

def setup
  sketch_title 'Index'
  @act_stroke_cap = SQUARE
  @act_random_seed = 0
end
```

---

```ruby
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
```
---
```ruby
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
        line(
          pos_x, pos_y,
          pos_x + width / TILE_COUNT, pos_y + height / TILE_COUNT
        )
      elsif toggle == 1
        stroke_weight(mouse_y / 20)
        line(
          pos_x, pos_y + width / TILE_COUNT,
          pos_x + width / TILE_COUNT, pos_y
        )
      end
    end
  end
end
```
---
class: demo, center, middle
# Demo
---
# gosu
---
```ruby
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
```
---
class: center, middle, depfu
# 3D

---
# mittsu
---
# inspiration: three.js
---
```ruby
scene = Mittsu::Scene.new
camera = Mittsu::PerspectiveCamera.new(75.0, ASPECT, 0.1, 1000.0)

renderer = Mittsu::OpenGLRenderer.new(
  width: SCREEN_WIDTH,
  height: SCREEN_HEIGHT,
  title: '02 Box Mesh Example'
)

geometry = Mittsu::BoxGeometry.new(1.0, 1.0, 1.0)
material = Mittsu::MeshBasicMaterial.new(color: 0x00ff00)
cube = Mittsu::Mesh.new(geometry, material)
scene.add(cube)

camera.position.z = 5.0

renderer.window.on_resize do |width, height|
  renderer.set_viewport(0, 0, width, height)
  camera.aspect = width.to_f / height.to_f
  camera.update_projection_matrix
end

renderer.window.run do
  cube.rotation.x += 0.1
  cube.rotation.y += 0.1
  renderer.render(scene, camera)
end
```
---
# SketchUp
---
class: demo, center, middle

# Demo
---
```ruby
def self.dialog
  labels = ['Width', 'Length', 'Deviation', 'Cube width']
  defaults = [20, 7, 0.5, 5]
  width, length, dev, cube_size = UI.inputbox(
    labels, defaults, "Pixel Text"
  )
  new(width, length, dev, cube_size).place_component
end

```
---
```ruby
def initialize(width, length, dev, cube_size=5)
  @definition = Sketchup.active_model.definitions.add "Pixel Text"
  @cube_size = cube_size
  width.times do |x|
    length.times do |y|
      z = dev * rand()
      offset = Geom::Point3d.new(
        x * @cube_size.mm,
        y * @cube_size.mm,
        z * @cube_size.mm
      )
      add_cube(offset)
    end
  end
end
```
---
```ruby
def add_cube(offset = Geom::Point3d.new(0,0,0))
  puts "cube at #{offset.inspect}"
  size = @cube_size
  group = @definition.entities.add_group
  points = [
    Geom::Point3d.new(0, 0, 0),
    Geom::Point3d.new(size.mm, 0, 0),
    Geom::Point3d.new(size.mm, size.mm, 0),
    Geom::Point3d.new(0, size.mm, 0)
  ]
  face = group.entities.add_face(points)
  face.pushpull(-size.mm)
  group.move!(offset)
end
```
---
class: center, middle, depfu

# Music / Sound

---
class: center, middle

# Sonic Pi
---
class: demo, center, middle

# Demo
---
class: center, middle
# Let's go deeper
---
# RubySynth
---
class: middle
1. Generate Audio
2. Send it to the soundcard
3. <s>Profit</s>Fun!
---
# soX
---

```sh
$SOUNDGEN | play -t raw -b 32 -r 44100 -c 1 -e \
                   floating-point --endian little -
```
---

```ruby
print [$FLOAT_VALUE].pack('e')
```
---
class: middle, center
# BUT WHAT VALUES, JAN?!?
---

```ruby
SFREQ = 44100
FREQ = 440

(SFREQ).times do |sample|
  t = sample.to_f / SFREQ.to_f # time in seconds
  period = 1.0 / (FREQ.to_f)
  v = 1.0
  v *= -1.0 if t % period > (period / 2)
  v *= 0.4
  print [v].pack('e')
end
```
---
class: contain
background-image: url(images/SquareWave.png)
---

```ruby
SFREQ = 44100
NOTES = [24, 24, 48, 37]
OFFSETS = [0, 0, 3, 7]
TEMPO = 120
def n2f(n)
  (2.0 ** ((n - 69) / 12.0)) * 440.0
end

(4 * SFREQ).times do |sample|
  t = sample.to_f / SFREQ.to_f # time in seconds
  s_per_b = 15.0 / TEMPO.to_f # seconds per quarternote
  b = t / s_per_b # quarternote
  l = (b / 4).floor # loop
  freq = n2f(NOTES[b % NOTES.length] + OFFSETS[l % OFFSETS.length])
  period = 1.0 / (freq.to_f)
  v = 1.0
  v *= -1.0 if t % period > (period / 2)
  v *= 0.4
  print [v].pack('e')
end
```
---
```ruby
# http://www.musicdsp.org/archive.php?classid=3#24
class MoogFilter
  def initialize
    @in1 = @in2 = @in3 = @in4 = 0
    @out1 = @out2 = @out3 = @out4 = 0
  end
  def run(input, fc, res)
    f = fc * 1.16;
    fb = res * (1.0 - 0.15 * f * f);
    input -= @out4 * fb;
    input *= 0.35013 * (f*f)*(f*f);
    @out1 = input + 0.3 * @in1 + (1 - f) * @out1; # Pole 1
    @in1  = input;
    @out2 = @out1 + 0.3 * @in2 + (1 - f) * @out2;  # Pole 2
    @in2  = @out1;
    @out3 = @out2 + 0.3 * @in3 + (1 - f) * @out3;  # Pole 3
    @in3  = @out2;
    @out4 = @out3 + 0.3 * @in4 + (1 - f) * @out4;  # Pole 4
    @in4  = @out3;
    return @out4;
  end
end
```
---
class: contain
background-image: url(images/Filter.png)
---
```ruby
# [...]
v *= -1.0 if t % period > (period / 2)
v = filter.run(v, 0.1, 3)
v *= 0.4
# [...]
```
---
```ruby
class Envelope
  def initialize(a,r)
    @a = a
    @r = r
  end
  def run(t)
    if t > @a + @r
      return 0
    elsif t > @a #release
      return 1 - ((1 / @r) * (t - @a))
    else
      return 1 / @a * t
    end

  end
end
```
---
class: contain
background-image: url(images/Envelope.png)
---
```ruby
# [...]
vol_ar = Envelope.new(0.001,0.1)
flt_ar = Envelope.new(0.02,0.04)
# [...]
t_in_b = t % s_per_b #time in quarternote
# [...]
v = filter.run(v, 0.01 + flt_ar.run(t_in_b) * 0.3, 3)
v *= vol_ar.run(t_in_b)
```
---
class: middle, center
# Sidenote:
## Web Audio API
---
class: middle, center
# MIDI
---
class: contain
background-image: url(images/midi_din.png)
---
class: contain, bottom
background-image: url(images/usb_a.jpg)

<a href="https://creativecommons.org/licenses/by-sa/3.0/" title="Attribution-ShareAlike 3.0">CC BY-SA 3.0</a>, <a href="https://en.wikipedia.org/w/index.php?curid=11856408">Image Details</a>
---
class: middle, center
# 1983
---
## Anatomy of a MIDI message
```
[ 0x90, 0x18, 0x7f ]
   ^      ^     ^
   |      |     `-------> Velocity
   |      `-------------> Note
   `--------------------> Note On, Channel 1
```
---
# portmidi
---
```ruby
require 'portmidi'

Portmidi.start
device = Portmidi.output_devices.find do |device|
  device.name.match(/IAC/)
end
output =  Portmidi::Output.new(device.device_id)

now = Portmidi.time
```
---

```ruby
messages = []
NOTES.each_with_index do |note, beat|
  messages << [now + (beat * 250), [0x90, note, 0x60], false]
  messages << [now + (beat * 250) + 125, [0x80, note, 0x60], false]
  if beat % 2 == 0
    messages << [now + (beat * 250), [0x91, 36, 0x60], false]
    messages << [now + (beat * 250) + 125, [0x81, 36, 0x60], false]
  else
    messages << [now + (beat * 250), [0x91, 36 + 6, 0x60], false]
    messages << [now + (beat * 250) + 125, [0x81, 36 + 6, 0x60], false]
  end
  if beat % 4 == 2
    messages << [now + (beat * 250), [0x91, 36 + 2, 0x60], false]
    messages << [now + (beat * 250) + 125, [0x81, 36 + 2, 0x60], false]    
  end
end
```
---

```ruby
Portmidi.on_timer do |time|
  sent = []

  messages.each do |msg|
    if time >= msg[0] && !msg[2]
      output.write_short(*msg[1])
      msg[2] = true
    end
    sent.each do |msg|
      messages.delete(msg)
    end
  end  
end

```
---
class: middle, center, demo
# Demo
---
# Launchpad
---
class: contain
background-image: url(images/launchpad_mini.png)

---

```ruby
require 'launchpad'
interaction = Launchpad::Interaction.new(
  device_name: 'Launchpad Mini'
)

flags = Hash.new(false)
# yellow feedback for grid buttons
interaction.response_to(:grid, :down) do |interaction, action|
  coord = 16 * action[:y] + action[:x]
  brightness = flags[coord] ? :off : :hi
  flags[coord] = !flags[coord]
  interaction.device.change(
    :grid,
    action.merge(:red => brightness, :green => brightness)
  )
end

interaction.start
```
---
class: middle, center, demo
# Demo
---
# MIDI files
---

# Webovision
---
```ruby
require 'midilib'
seq = MIDI::Sequence.new()
# Read the contents of a MIDI file into the sequence.
File.open(infile, 'rb') { | file |
    seq.read(file)
}
tracks = []
seq.tracks.each do |track|
  tracks << {
    name: track.name,
    events: track.events.map do |event|
      if event.is_a?(MIDI::NoteOn)
        [:noteon, event.time_from_start,
          event.channel, event.note, event.velocity]
      elsif event.is_a?(MIDI::NoteOff)
        [:noteoff, event.time_from_start,
          event.channel, event.note, event.velocity]
      elsif event.is_a?(MIDI::Controller)
        [:controller, event.time_from_start,
          event.channel, event.controller, event.value]
      elsif event.is_a?(MIDI::ProgramChange)
        [:progchange, event.time_from_start,
          event.channel, event.program]
      else
        puts event.inspect;
        nil
      end
    end.compact
  }
end
```
---
class: middle, center, demo
# Demo
---
class: middle, center, depfu
# All together now
---
class: middle, center, demo
# Demo
---
# [halfbyte/Gosu-Minesweeper#launchpad_support](https://github.com/halfbyte/Gosu-Minesweeper/tree/launchpad_support)
---
class: center, middle, depfu

# Why?
---
class: depfu, middle, center
# ❤️ Thank you ❤️
## halfbyte/ruby_for_artists
## 🎹 ✏️
## @halfbyte
## depfu.com
