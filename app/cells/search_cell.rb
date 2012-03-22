class SearchCell < Cell::Rails

  def results(params)
    unless params[:q].blank?
      @query = params[:q]

      @buildings = OsmBuilding.where('name ILIKE ?', "%#{@query}%")
    end

    render
  end

end
