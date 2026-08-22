class Role < ApplicationRecord

  ## RELATIONSHIPS

    has_many :users

  ## INSTANCE METHODS
    
    def admin?
      self.name == "admin"
    end

    def user?
      self.name == "user"
    end

end