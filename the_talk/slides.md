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

# Why?

---
class: center, middle, depfu

# 2D

---
class: center, middle

# offline

---

# [halfbyte/calgen](https://github.com/halfbyte/calgen)

---

class: contain
background-image: url(images/real_calendar.jpeg)

---
class: contain
background-image: url(images/calendar_januar.png)
---
# gem install 'prawn'
---
class: middle
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
class: middle
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
class: middle
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
class: center, middle, depfu
# 3D

---
# mittsu
---
# inspiration: three.js


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
class: middle
```sh
$SOUNDGEN | play -t raw -b 32 -r 44100 -c 1 -e \
                   floating-point --endian little -
```
---
class: middle
```ruby
print [$FLOAT_VALUE].pack('e')
```
---
class: middle, center
# BUT WHAT VALUES, JAN?!?
---
class: middle
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
class: middle
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
class: middle
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

class: middle
```ruby
# [...]
v *= -1.0 if t % period > (period / 2)
v = filter.run(v, 0.1, 3)
v *= 0.4
# [...]
```
---
class: middle
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
class: middle
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
class: middle
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
class: middle
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
class: middle
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
class: middle
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
class: middle
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
class: depfu, middle, center
# ❤️ Thank you ❤️
## halfbyte/ruby_for_artists
## 🎹 ✏️
## @halfbyte
## depfu.com

---
