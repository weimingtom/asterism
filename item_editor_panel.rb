require "wx"

module Asterism
  
  class ItemEditorPanel < Wx::Panel
    
    def initialize(parent)
      super(parent, -1)
      l1 = Wx::StaticText.new(self, -1, "Name:")
      t1 = Wx::TextCtrl.new(self, -1)
      l2 = Wx::StaticText.new(self, -1, "Cost:")
      t2 = Wx::TextCtrl.new(self, -1)
      
      sizer = Wx::FlexGridSizer.new(0, 2, 8, 8)
      sizer.add(l1)
      sizer.add(t1)
      sizer.add(0, 0)
      sizer.add(l2)
      sizer.add(t2)
      
      self.sizer = sizer
      self.auto_layout = true
    end
    
  end
  
end
