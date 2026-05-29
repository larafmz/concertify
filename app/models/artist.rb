class Artist < ApplicationRecord

  ## RELATIONSHIPS

    has_many :concerts
    has_many_attached :photos
    has_many :interactuables
    belongs_to :genre, optional: true

  ## VALIDATIONS

    validates :name, :ticketmaster_id, presence: true
    validates :ticketmaster_id, uniqueness: true
    
  ## INSTANCE METHODS

    def complete_name
      name
    end

end