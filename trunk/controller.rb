module Asterism
  
  class Controller
    
    def initialize(model)
      @model = model
      @views = []
    end
    
    def update_attr(key, value)
      @model[key] = value
    end
    
    def add(key, value)
      @model.transaction do
        @model[key] = value
        on_updated_model(:add, value)
      end
    end
    
    def remove(key)
    end
    
    def add_view(view)
      unless @views.include?(view)
        @views << view
        if @model.kind_of?(PStore)
          models = @model.transaction do
            @model.roots.sort.map do |id|
              @model[id]
            end
          end
          on_updated_model(:init, models)
        else
          on_updated_model(:init, @model)
        end
      end
    end
    
    def remove_view(view)
      @views.delete(view)
    end
    
    def next_id
      @model.transaction do
        (@model.roots.max || 0) + 1
      end
    end
    
    def model_name
      @model[:name]
    end
    
    protected
    
    def on_updated_model(operate, model)
      @views.each do |view|
        view.on_updated_model(operate, model)
      end
    end
    
  end
  
end
