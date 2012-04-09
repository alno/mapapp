collection @photos

attributes :id, :image_url, :width, :height, :url

glue :location do
  attributes :x => :lng, :y => :lat
end

node :popup do |photo|
  controller.render_to_string "photos/#{photo.service}.html", :layout => nil, :locals => { :photo => photo }
end
