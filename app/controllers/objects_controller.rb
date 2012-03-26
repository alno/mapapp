class ObjectsController < ApplicationController

  def show
    @object = OsmObject.find params[:id]
  end

  def page
    @object = OsmObject.find params[:id]
    @title = @object.name

    render :layout => 'page'
  end

end
