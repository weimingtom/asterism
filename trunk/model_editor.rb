require "wx"

module Asterism
  
  class ModelEditor < Wx::ListCtrl
    
    def initialize(parent, model, data)
      style = Wx::LC_REPORT | Wx::LC_VIRTUAL | Wx::LC_HRULES | Wx::LC_VRULES
      super(parent, :style => style)
      insert_column(0, "id")
      model[:columns].each_with_index do |column, i|
        insert_column(i + 1, column[:name].to_s)
      end
      set_item_count(data.size)
    end
    
    def on_get_item_attr(item)
    end
    
    def on_get_item_text(item, col)
      if col == 0
        "#{item}"
      else
        "#{col}"
      end
    end
    
    def on_get_item_column_image(item, col)
      -1
    end
    
  end
  
end
