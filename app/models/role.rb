class Role < ApplicationRecord

  ## RELATIONSHIPS

    has_many :users

  ## CLASS METHODS

    def self.get_user_role
      Role.where(name: "user").first
    end

  ## INSTANCE METHODS
    
    def admin?
      self.name == "admin"
    end

    def user?
      self.name == "user"
    end

end