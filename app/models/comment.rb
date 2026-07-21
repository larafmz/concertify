class Comment < ApplicationRecord

    ## RELATIONSHIPS
    
        belongs_to :user
        belongs_to :interactuable

    ## VALIDATIONS

        validates :text, presence: true



end