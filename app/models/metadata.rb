class Metadata

  include ActiveAttr::Attributes

  def categories
    Category.all
  end

end
