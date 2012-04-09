collection @photos

attributes :id, :service, :image_url, :width, :height, :url, :title, :author_url, :author_name

glue :location do
  attributes :x => :lng, :y => :lat
end
