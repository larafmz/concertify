class FavoriteArtist < ApplicationRecord
  
  belongs_to :user
  belongs_to :artist

  ## VALIDATIONS

    validate :max_favorite_artists

  ## VALIDATION METHODS

    def max_favorite_artists
      if user.favorite_artists.size+1 > 4
        errors.add(:favorite_artists, "(TO/DO) no puede tener más de 4 artistas favoritos")
      end
    end

end
