require "wx"
require "starruby"

module Wx
  class DC
    def draw_texture(texture, x, y)
      image = Wx::Image.new(texture.width, texture.height)
      image.data = texture.dump("rgb")
      bitmap = Wx::Bitmap.new(image)
      draw_bitmap(bitmap, x, y, false)
    end
  end
end

require "item_editor_panel"

module Asterism
  class MainFrame < Wx::Frame
    def initialize(title)
      super(nil, :title => title)
      center(Wx::BOTH)
      ItemEditorPanel.new(self)
    end
  end
end

Wx::App.run do
  x = Asterism::MainFrame.new("Asterism")
  x.show
end
