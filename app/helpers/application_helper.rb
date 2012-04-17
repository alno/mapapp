module ApplicationHelper

  def osm_browse_link(model)
    link_to t("info.links.osm_browse"), "http://www.openstreetmap.org/browse/#{model.osm_type}/#{model.id}", :target => '_blank'
  end

  def osm_history_link(model)
    link_to t("info.links.osm_history"), "http://www.openstreetmap.org/browse/#{model.osm_type}/#{model.id}/history", :target => '_blank'
  end

end
