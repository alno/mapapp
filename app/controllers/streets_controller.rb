class StreetsController < ApplicationController

  def show
    @street = OsmStreet.find params[:id]
  end

end
