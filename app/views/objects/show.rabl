object @object

attributes :id, :name, :table, :types, :address, :tags

glue :center do
  attributes :x => :lng, :y => :lat
end
