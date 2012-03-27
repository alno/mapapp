module OsmModels::Name

  extend ActiveSupport::Concern

  def name
    self['name'] || (respond_to?(:category) && category.try(:default_object_name)) || I18n.t("models.#{self.class.name.underscore}.default_name")
  end

end
