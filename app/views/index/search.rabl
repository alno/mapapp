object @search

attributes :query, :params

node(:current_page) { |search| search.results.current_page }
node(:page_count) { |search| search.results.page_count }
node(:total_count) { |search| search.results.total_count }

child :results => :results do
  attributes :name, :table, :types, :address

  glue :center do
    attributes :x => :lng, :y => :lat
  end
end
