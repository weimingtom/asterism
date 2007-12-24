require "wx"
require "starruby"
require "yaml"
require "yaml/store"

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
require "model"
require "controller"

module Asterism
  
  class ModelSelector < Wx::TreeCtrl
    
    def initialize(parent, editor_panel, model_schemas)
      super(parent, :style => Wx::TR_SINGLE | Wx::TR_DEFAULT_STYLE)
      root = add_root("Models")
      select_item(root)
      nodes   = {}
      editors = {}
      model_schemas.each do |schema|
        name = schema[:name]
        nodes[name] = append_item(root, name)
        model = Model.new(YAML::Store.new("data/#{name}.yaml"))
        controller = Controller.new(model)
        editor = editors[name] = ModelEditor.new(editor_panel, controller)
        editor_panel.sizer.add(editor, 1, Wx::EXPAND)
        editor.hide
      end
      evt_tree_sel_changed(get_id) do |e|
        editors.values.each{|v| v.hide}
        if editor = editors[nodes.index(e.item)]
          editor.show
          editor_panel.sizer.layout
        end
      end
      expand_all
    end
    
  end
  
  class MainFrame < Wx::Frame
    def initialize(title)
      super(nil, :title => title, :size => [800, 600])
      center(Wx::BOTH)
      
      # menu bar
      menu_help = Wx::Menu.new
      menu_bar = Wx::MenuBar.new
      menu_bar.append(menu_help, "&Help")
      self.menu_bar = menu_bar
      
      # status bar
      create_status_bar
      
      # project
      project = nil
      open("project1.yaml") do |fp|
        project = YAML.load(fp)
      end
      
      splitter = Wx::SplitterWindow.new(self)
      
      editor_panel = Wx::Panel.new(splitter)
      editor_panel.sizer = Wx::BoxSizer.new(Wx::VERTICAL)
      
      panel = Wx::Panel.new(splitter)
      panel.sizer = Wx::BoxSizer.new(Wx::VERTICAL)
      panel.sizer.add(ModelSelector.new(panel, editor_panel, project[:model_schemas]), 1, Wx::EXPAND)
      
      splitter.split_vertically(panel, editor_panel, 120)
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
