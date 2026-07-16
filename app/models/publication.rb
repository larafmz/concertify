class Publication < Interactuable

    ## RELATIONSHIPS
    
    belongs_to :artist, optional: true
    belongs_to :concert, optional: true

end