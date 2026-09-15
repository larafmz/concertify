class Country < ApplicationRecord

  ## RELATIONSHIPS

    has_many :ubications

  ## VALIDATIONS

    validates :name, :code, presence: true
    validates :code, uniqueness: true
    
  ## INSTANCE METHODS

    def complete_name
      name
    end

    def translation
      if I18n.locale == :en
        name
      else
        I18n.t(name)
      end
    end

end