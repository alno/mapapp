class IndexController < ApplicationController

  def search
    @search = Search.new(params)
  end

  def counts
    @search = Search.new(params)
  end

end
