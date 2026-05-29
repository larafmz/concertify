class Genre < ApplicationRecord

  ## RELATIONSHIPS

    has_many :artists

  ## VALIDATIONS

    validates :name, presence: true
    
end