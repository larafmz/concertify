class Genre < ApplicationRecord

  ## RELATIONSHIPS

    has_many :artists

  ## VALIDATIONS

    validates :name, presence: true

  ## INSTANCE METHODS

  def translation
    return name if I18n.locale == :en
    I18n.t("genres.#{name}")
  end
    
end