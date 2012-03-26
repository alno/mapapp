class PagesController < ApplicationController

  def show
    @page = Page.find_by_slug(params[:id]) || Page.find(params[:id])
  end

end
