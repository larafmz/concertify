class FavoriteArtist < ApplicationRecord
  
  belongs_to :user
  belongs_to :artist

  ## VALIDATIONS

    validate :max_favorite_artists

  ## VALIDATION METHODS

    def max_favorite_artists
      if user.favorite_artists.size+1 > 4
        errors.add(:favorite_artists, I18n.t("messages.cant_mark_as_favorite"))
      end
    end

end
