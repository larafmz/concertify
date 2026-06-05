class FutureAssistance < ApplicationRecord

  ##CONFIGURATIONS

  kindable :concert_seat, { :pista => 0, :grada => 1, :vip => 2, :otro => 3 }

  ## RELATIONSHIPS

    belongs_to :user
    belongs_to :concert
    belongs_to :interactuable, optional: true

  ## VALIDATIONS
  
  
  ## INSTANCE METHODS


end