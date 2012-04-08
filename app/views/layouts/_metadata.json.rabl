object Metadata.new

child :categories do
  attributes :id, :parent_id, :name, :table, :types, :icon
end

node :config do
  Mapapp.config
end
