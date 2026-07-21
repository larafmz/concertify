class Repost < ApplicationRecord

    ## RELATIONSHIPS
    
        belongs_to :user
        belongs_to :interactuable

    ## VALIDATIONS

        validates :user_id, uniqueness: { scope: :interactuable_id }
        validate :cant_repost_own

    ## VALIDATION METHODS

        def cant_repost_own
            if user.id == interactuable.user.id
                errors.add(:photos, t("messages.cant_repost_own"))
            end
        end

end