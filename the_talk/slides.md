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

# project 001: calgen

---

// TODO: insert image

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


# 3D

---