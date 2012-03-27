module ApplicationHelper

  def osm_link(model)
    link_to t("info.links.osm_browse"), "http://www.openstreetmap.org/browse/#{model.osm_type}/#{model.id}", :target => '_blank'
  end

end
