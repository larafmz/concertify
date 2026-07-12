class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.singular
    self.model_name.human
  end

  def self.plural
    self.model_name.human(count: 2)
  end

  def self.han(attribute)
    self.human_attribute_name(attribute)
  end

end
