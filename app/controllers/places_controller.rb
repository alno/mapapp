class PlacesController < ApplicationController

  def show
    @place = OsmPlace.find params[:id]
  end

  def page
    @place = OsmPlace.find params[:id]
    @title = @place.name

    render :layout => 'page'
  end

end
