class Role < ApplicationRecord

  ## RELATIONSHIPS

    has_many :users

  ## SCOPES

    scope :user, -> { where(name: "user").first }

  ## INSTANCE METHODS
    
    def admin?
      self.name == "admin"
    end

    def user?
      self.name == "user"
    end

end