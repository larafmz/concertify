class ChatUser < ApplicationRecord

  ## RELATIONSHIPS

    belongs_to :user
    belongs_to :chat

  ## SCOPE
  
    scope :unread, -> { where(read_at: nil) }

  ## VALIDATIONS

    validates :user_id, uniqueness: { scope: :chat_id }

  ## CALLBACKS

   after_update_commit :broadcast_change, if: :saved_change_to_read_at?

  ## CALLBACKS METHODS

  private

    def broadcast_change
      #update sidebar
      broadcast_replace_to( # se reemplaza todo el sidebar
        # hace actualizacion a a todos los usuarios, aunque no esten en el mismo que esten en el chat
        [ user, "sidebar" ], # = turbo_stream_from current_user, "sidebar" if @chat
        target: "chat_sidebar", # {id: "chat_sidebar" ... }
        partial: "chats/sidebar",
        locals: { chats: user.chats, current_user: user }
      )
    
      #update header
      broadcast_replace_to( # se reemplaza todo el trozo del header 
        # hace actualizacion a a todos los usuarios
        [ user, "messages_header" ], # = turbo_stream_from current_user, "messages_header"
        target: "messages_header", # {id: "messages_header" ... }
        partial: "layouts/shared/messages_bubble",
        locals: { current_user: user }
      )

    end

  ## INSTANCE METHODS

  public

    def mark_as_read
      self.update(read_at: Time.current)
    end

    def mark_as_unread
      self.update(read_at: nil)
    end

    def read?
      read_at.present?
    end

end