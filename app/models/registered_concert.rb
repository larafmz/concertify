class RegisteredConcert < Interactuable

    validates :concert_id, presence: true
    validates :concert_id, uniqueness: { scope: :user_id, message: "Ya has registrado este concierto" }

end