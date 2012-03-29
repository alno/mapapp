class ObjectsController < ApplicationController

  def show
    @object = OsmObject.find params[:id]
  end

end
