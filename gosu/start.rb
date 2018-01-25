require 'gosu'
class Tutorial < Gosu::Window
  def initialize
    super 1024, 768
    self.caption = "Tutorial Game"
    @code = Gosu::Image.new('test.png')
  end

  def update
    # @slide = Gosu::Image.from_text('Setup', 100, font: 'fonts/Coolville.ttf')
  end

  def draw
    Gosu.draw_rect(0, 0, width, height, Gosu::Color::WHITE, 0)
    @code.draw_as_quad(
      (width - (@code.width / 2)) / 2,
      (height - @code.height) / 2,
      Gosu::Color::WHITE,
      (width - (@code.width / 2)) / 2 + (@code.width / 2),
      (height - @code.height) / 2,
      Gosu::Color::WHITE,
      (width - @code.width) / 2,
      (height - @code.height) / 2 + @code.height,
      Gosu::Color::WHITE,
      (width - @code.width) / 2 + @code.width,
      (height - @code.height) / 2 + @code.height,
      Gosu::Color::WHITE,
      1
    )

    #@image.draw((width - @image.width) / 2,(height - @image.height) / 2,1, 1, 1, Gosu::Color::BLACK)
  end

  def center_image(image, color=Gosu::Color::WHITE)
    image.draw((width - image.width) / 2,(height - image.height) / 2,1, 1, 1, color)
  end
end

Tutorial.new.show
