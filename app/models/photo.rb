class Photo < ActiveRecord::Base

  scope :in_bbox, lambda{|bbox| where("location && Geography(?::box2d)", "BOX(#{bbox[0]} #{bbox[1]}, #{bbox[2]} #{bbox[3]})") }
  scope :order_in_bbox, lambda{|bbox| order("ST_Distance(location, 'POINT(#{(bbox[0].to_f+bbox[2].to_f) * 0.5} #{(bbox[1].to_f+bbox[3].to_f) * 0.5})'::geography) ASC") }

end
