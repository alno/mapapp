class PlacesController < ApplicationController

  def show
    @place = OsmPlace.find params[:id]
  end

end
