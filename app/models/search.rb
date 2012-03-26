class Search

  include ActiveAttr::Attributes
  include ActiveAttr::MassAssignment

  attribute :params
  attribute :query
  attribute :results

  def self.search(params)
    if params[:q].blank?
      nil
    else
      query = params[:q]
      options = { :page => params[:page] || 1, :per_page => 15 }

      unless params[:lat].blank? || params[:lng].blank?
        options[:geo] = [params[:lat].to_f / 180 * Math::PI, params[:lng].to_f / 180 * Math::PI]
        options[:latitude_attr] = "latitude"
        options[:longitude_attr] = "longitude"
        options[:order] = "@geodist ASC, @relevance DESC"
      end

      Search.new(:params => params, :query => query, :results => ThinkingSphinx.search(query, options))
    end
  end

end
