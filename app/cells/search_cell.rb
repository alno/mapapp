class SearchCell < Cell::Rails

  def results(params)
    unless params[:q].blank?
      @query = params[:q]

      options = {}

      unless params[:lat].blank? || params[:lng].blank?
        options[:geo] = [params[:lat].to_f / 180 * Math::PI, params[:lng].to_f / 180 * Math::PI]
        options[:latitude_attr] = "latitude"
        options[:longitude_attr] = "longitude"
      end

      options[:order] = "@geodist ASC, @relevance DESC"

      @buildings = ThinkingSphinx.search @query, options
    end

    render
  end

end
