class PlacesController < ApplicationController

  def show
    @place = OsmPlace.find params[:id]
  end

  def info
    @place = OsmPlace.find params[:id]
    @title = @place.name

    render :layout => 'info'
  end

end
