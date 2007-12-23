require "wx"
require "starruby"
require "yaml"

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

require "model_editor"

module Asterism
  
  class ModelSelector < Wx::TreeCtrl
    
    def initialize(parent, editor_panel, models)
      super(parent, :style => Wx::TR_SINGLE | Wx::TR_DEFAULT_STYLE)
      root = add_root("Models")
      select_item(root)
      nodes   = {}
      editors = {}
      models.each do |model|
        nodes[model] = append_item(root, model[:name])
        editor = editors[model] = ModelEditor.new(editor_panel, model, [])
        editor_panel.sizer.add(editor, 0, Wx::EXPAND | Wx::ALL)
        editor.hide
      end
      evt_tree_sel_changed(get_id) do |e|
        editors.values.each{|v| v.hide}
        if editor = editors[nodes.index(e.item)]
          editor.show
          editor_panel.sizer.recalc_sizes
        end
      end
      
      expand_all
    end
    
  end
  
  class MainFrame < Wx::Frame
    def initialize(title)
      super(nil, :title => title, :size => [640, 480])
      center(Wx::BOTH)
      
      # menu bar
      menu_help = Wx::Menu.new
      menu_bar = Wx::MenuBar.new
      menu_bar.append(menu_help, "&Help")
      self.menu_bar = menu_bar
      
      # status bar
      create_status_bar
      
      # project
      models = nil
      open("project1.yaml") do |fp|
        models = YAML.load(fp)
      end

      main_splitter_class = Class.new(Wx::SplitterWindow)
      main_splitter_class.class_eval %Q{
        def initialize(parent)
          super(parent)
          evt_splitter_sash_pos_changed(object_id) do |e|
            e.sash_position = self.sash_position = 200
          end
          evt_splitter_sash_pos_changing(object_id) do |e|
            e.sash_position = self.sash_position = 200
          end
        end
      }
      splitter = main_splitter_class.new(self)
      
      editor_panel = Wx::Panel.new(splitter)
      editor_panel.background_colour = Wx::Colour.new("GREY")
      editor_panel.sizer = Wx::BoxSizer.new(Wx::VERTICAL)
      
      panel = Wx::Panel.new(splitter)
      panel.sizer = Wx::BoxSizer.new(Wx::VERTICAL)
      panel.sizer.add(ModelSelector.new(panel, editor_panel, models), 1, Wx::EXPAND | Wx::ALL)
      
      splitter.split_vertically(panel, editor_panel, 200)
      splitter.minimum_pane_size = 20
    end
  end
  
  class MainApp < Wx::App
    def on_init
      MainFrame.new("Asterism").show
    end
  end
end

Asterism::MainApp.new.main_loop
