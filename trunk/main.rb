require "wx"

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
      
      panel_sizer = Wx::BoxSizer.new(Wx::HORIZONTAL)
      panel_sizer.add((panel = Wx::Panel.new(self)), 1, Wx::EXPAND | Wx::ALL)
      self.sizer = panel_sizer
      
      sizer = Wx::BoxSizer.new(Wx::VERTICAL)
      data = {}
      if File.file?("data")
        open("data", "r") do |fp|
          data = eval(fp.read)
        end
      end
      sizer.add(ItemEditorPanel.new(panel, data), 1, Wx::ALIGN_TOP | Wx::ALL)
      
      id = Wx::ID_HIGHEST
      buttons_sizer = Wx::BoxSizer.new(Wx::HORIZONTAL)
      b = Wx::Button.new(panel, (id += 1), "OK", :size => [100, 30])
      evt_button(b.id) do |e|
        open("data", "w") do |fp|
          fp.puts("{")
          begin
            data.each do |key, value|
              case value
              when String
                fp.puts("  #{key.inspect} => #{value.dump},")
              when Symbol
                fp.puts("  #{key.inspect} => #{value.inspect},")
              when Integer
                fp.puts("  #{key.inspect} => #{value},")
              end
            end
          ensure
            fp.puts("}")
          end
          close
        end
      end
      buttons_sizer.add(b, 0)
      buttons_sizer.add(10, 0)
      b = Wx::Button.new(panel, (id += 1), "Cancel", :size => [100, 30])
      evt_button(b.id) do |e|
        close
      end
      buttons_sizer.add(b, 0)
      sizer.add(buttons_sizer, 0, Wx::ALIGN_BOTTOM | Wx::ALIGN_RIGHT)
      
      panel.sizer = Wx::BoxSizer.new(Wx::HORIZONTAL)
      panel.sizer.add(sizer, 1, Wx::EXPAND | Wx::ALL, 10)
    end
  end
  
  class MainApp < Wx::App
    def on_init
      MainFrame.new("Asterism").show
    end
  end
end

Asterism::MainApp.new.main_loop
