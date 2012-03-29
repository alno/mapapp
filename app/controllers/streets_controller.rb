class StreetsController < ApplicationController

  def show
    @street = OsmStreet.find params[:id]
  end

  def page
    @street = OsmStreet.find params[:id]
    @title = @street.name

    render :layout => 'page'
  end

end
