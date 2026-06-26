class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ## RELATIONSHIPS

    has_many :interactuables, dependent: :destroy
    has_one :ubication

  ## VALIDATIONS

    validates :email, :username, :name, presence: true
    validates :email, :username, uniqueness: true

end
