class Category < ActiveRecord::Base

  self.inheritance_column = "ar_type"

  has_ancestry

end
