class Artist < ApplicationRecord

  ## RELATIONSHIPS

    has_many :concerts
    has_one_attached :photo

  ## VALIDATIONS

    validates :name, :ticketmaster_id, presence: true
    validates :ticketmaster_id, uniqueness: true
    
  ## INSTANCE METHODS

    def complete_name #Complete name
      name
    end

end