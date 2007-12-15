module Asterism
  
  class TexturePanel < Wx::Panel
    
    attr_reader :texture
    
    def initialize(parent, id = Wx::ID_ANY)
      super(parent, id)
      @texture = StarRuby::Texture.load("town01_a")
      font = StarRuby::Font.new("Arial", 48)
      color = StarRuby::Color.new(255, 255, 255)
      @texture.render_text("Star Ruby rules!!", 8, 8, font, color, true)
      evt_paint do |e|
        paint do |dc|
          dc.clear
          image = Wx::Image.new(@texture.width, @texture.height)
          image.data = @texture.dump("rgb")
          bitmap = Wx::Bitmap.new(image)
          dc.draw_bitmap(bitmap, 0, 0, false)
        end
      end
      evt_size do |e|
      end
    end
    
  end
  
end
