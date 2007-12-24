require "wx"
require "view"

module Asterism
  
  class ModelEditor < Wx::Panel
    
    def initialize(parent, controller)
      id = Wx::ID_HIGHEST
      
      super(parent)
      
      splitter = Wx::SplitterWindow.new(self)
      
      list_panel = Wx::Panel.new(splitter)
      
      style = Wx::LC_REPORT | Wx::LC_HRULES | Wx::LC_VRULES
      list = Wx::ListCtrl.new(list_panel, :style => style)
      (class << list; self; end).class_eval %Q{
        include View
        
        def add_model_item(model)
          index = insert_item(item_count, model[:name])
          item = get_item(index)
          (class << item; self; end).class_eval %Q{
            include View
            def on_updated_model(operate, model_item)
            end
          }
          item.controller = Controller.new(model)
        end
        
        private :add_model_item
        
        def on_updated_model(operate, model)
          case operate
          when :init
            model.transaction do
              model.roots.sort.each do |id|
                add_model_item(model[id])
              end
            end
            refresh
          when :add
            add_model_item(model)
            refresh
          end
        end
      }
      list.controller = controller
      list.insert_column(0, "Name")
      list.set_column_width(0, 180)
      
      add_button = Wx::Button.new(list_panel, id += 1, :label => "Add")
      evt_button(add_button.get_id) do |e|
        controller.add(controller.next_id, {:name => ""})
      end
      
      button_sizer = Wx::BoxSizer.new(Wx::HORIZONTAL)
      button_sizer.add(add_button, 0)
      
      list_panel.sizer = Wx::BoxSizer.new(Wx::VERTICAL)
      list_panel.sizer.add(list, 1, Wx::EXPAND)
      list_panel.sizer.add(button_sizer, 0, Wx::BOTTOM)
      
      sme = Wx::Panel.new(splitter)
      splitter.split_vertically(list_panel, sme, 200)
      splitter.minimum_pane_size = 10
      
      self.sizer = Wx::BoxSizer.new(Wx::VERTICAL)
      # self.sizer.add(button_sizer, 0, Wx::BOTTOM)
      self.sizer.add(splitter, 1, Wx::EXPAND)
    end
    
  end
  
end
