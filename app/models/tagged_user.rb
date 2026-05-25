class TaggedUser < ApplicationRecord

  ## RELATIONSHIPS

    belongs_to :user
    belongs_to :interactuable

end
