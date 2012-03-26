class Category < ActiveRecord::Base

  self.inheritance_column = "ar_type"

  has_ancestry

  def object_count
    Search.empty.category_counts[id]
  end

end
