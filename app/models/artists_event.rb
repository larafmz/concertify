class ArtistsEvent < ApplicationRecord

  ## RELATIONSHIPS

    belongs_to :artist
    belongs_to :event

end