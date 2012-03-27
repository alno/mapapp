object @road

attributes :id, :name, :table, :types, :tags

glue :center do
  attributes :x => :lng, :y => :lat
end
