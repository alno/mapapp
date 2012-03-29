object @building

attributes :id, :name, :table, :types, :tags

glue :center do
  attributes :x => :lng, :y => :lat
end

node :info do
  controller.render_to_string 'info'
end
