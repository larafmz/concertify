class FutureAssistance < ApplicationRecord

  ##CONFIGURATIONS

  kindable :concert_seat { 0 => "Pista", 1 => "Grada", 2 => "VIP", 3 => "Otro" }

  ## RELATIONSHIPS

    belongs_to :user
    belongs_to :concert
    belongs_to :interactuable, optional: true

  ## VALIDATIONS
  
  
  ## INSTANCE METHODS


end