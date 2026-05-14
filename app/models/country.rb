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

end