class Like < ApplicationRecord

    ## RELATIONSHIPS
    
        belongs_to :user
        belongs_to :interactuable

    ## VALIDATIONS

    validates :user_id, uniqueness: { scope: :interactuable_id }
    validate :cant_like_own

    ## SCOPES

    ## VALIDATION METHODS

        def cant_like_own
            if user.id == interactuable.user.id
                errors.add(:photos, t("messages.cant_like_own"))
            end
        end

    ## INSTANCE METHODS


end