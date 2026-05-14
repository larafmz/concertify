class Ubication < ApplicationRecord

  ## RELATIONSHIPS

    belongs_to :country
    has_many :concerts

  ## VALIDATIONS

    validates :city, :state, presence: true
    
  ## INSTANCE METHODS

    def complete_name 
      "#{address}, #{city}, #{state}, #{country.name}"
    end

end