class Publication < Interactuable

    ## RELATIONSHIPS
    
    belongs_to :artist
    belongs_to :future_assistance, optional: true
    belongs_to :concert, optional: true



end