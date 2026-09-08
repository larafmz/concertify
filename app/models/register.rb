class Register < Interactuable

  ## CONFIGURATIONS

   MAX_PHOTOS = 10

  ## RELATIONSHIPS
    
    belongs_to :event

  ## VALIDATIONS

    validates :event_id, presence: true
    validates :event_id, uniqueness: { scope: :user_id, message: I18n.t('messages.event_already_registered') }
    validate :photos_limit

  ## SCOPES

    scope :by_artist, ->(artist_id) { left_joins(event: :artists).where(artists: { id: artist_id }) }
    scope :with_review, -> { where.not(review: nil).where("TRIM(review) != ''") }
    scope :by_friends, -> (current_user) { where(user_id: current_user.followings.pluck(:followed_id)) }

  
  ## CALLBACKS

    after_destroy_commit :exit_chat

  ## VALIDATION METHODS

  private

    def photos_limit
        if photos.attached? && photos.count > MAX_PHOTOS
            errors.add(:photos, I18n.t("messages.max_upload", count: MAX_PHOTOS))
        end
    end

  # CALLBACKS METHODS

  public

    def exit_chat
      event.chat.exit_chat(user_id) if event&.chat
    end

  ## CLASS METHODS

    def self.do_search(params, user: nil)
      return Register.viewables(user) unless user.present?
      return user.registers.left_joins(:likes).group(:id).order("COUNT(likes.id) DESC") if params[:filter] && params[:filter]=="populars" 
      user.registers.order(created_at: :desc)
    end

    def self.feed(user)
      return Register.all unless user.present?

      reposts = Repost.for_registers.where(user_id: [user.id, *user.following_ids]).includes(:interactuable, :user)
      regs = Register.by_friends(user)
      regs = regs.where.not(id: reposts.pluck(:interactuable_id)) # Exclude registers that have been reposted by the user or their followings

      feed = (regs.viewables(user).map do |reg|
        {
          register: reg,
          repost: nil,
          date: reg.created_at
        }
        end + reposts.map do |repost|
        {
          register: repost.interactuable,
          repost: repost,
          date: repost.created_at
        }
      end).sort_by { |obj| -obj[:date].to_i }
      feed
    end

    def self.viewables(user)
      if user.present?
        #Remove Registers from users than have BLOCKED ME
        regs = Register.where.not(user_id: Relation.where(followed_id: user.id, relation_type: 1).select(:follower_id))
        #Remove Registers from users than I HAVE BLOCKED
        regs.where.not(user_id: Relation.where(follower_id: user.id, relation_type: 1).select(:followed_id))
      else
        Register.all
      end
    end

  ## INSTANCE METHODS

    def get_rating
      rating = self.rating.nil? ? 0 : self.rating
      return "★" * rating
    end

end