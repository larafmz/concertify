class ChatsController < ApplicationController

  before_action :set_params

  def index
  end

  def show
    @chat_entries = @chat.chat_entries.order("created_at ASC") if @chat
    current_user.notifications.for_chats.where(notificable_id: @chat.id).update(opened: true)
  end

  def send_message
    @chat = Chat.new(event_id: params[:event_id]) if !@chat.present?

    if params[:user_id] && !@chat.chat_users.exists?(user_id: params[:user_id])
      @chat.chat_users << ChatUser.new(user_id: params[:user_id]) 
    end

    if !@chat.chat_users.exists?(user_id: current_user.id)
      @chat.chat_users << ChatUser.new(user_id: current_user.id) 
      ChatEntry.create(chat_id: @chat.id, user_id: current_user.id, text: "entered_chat", chat_type: 1)
    end
    
    @chat.save!

    ChatEntry.create(chat_id: @chat.id, user_id: current_user.id, text: params[:message], chat_type: 0)
    Notification.create_for_chat(current_user.id, @chat.id)
    head :ok
  end

  def exit
    ChatUser.destroy_by(user_id: params[:user_id], chat_id: params[:id])
    ChatEntry.create(chat_id: params[:id], user_id: params[:user_id], text: "exited_chat", chat_type: 1)
    redirect_to chats_path
  end

  private 

    def set_params
      if !current_user.present?
        redirect_back fallback_location: root_path if !current_user.present?
        return
      else
        if params[:user_id]
          @user = User.find(params[:user_id])
          @chat = Chat.by_users(current_user.id, @user.id).first
        elsif params[:event_id]
          @event = Event.find(params[:event_id])
          @chat = Chat.find_by(event_id: params[:event_id])
        elsif params[:id]
          @chat = Chat.find(params[:id])
          @event = @chat.event if @chat.event.present?
          @user = @chat.other_user(current_user) if !@chat.event.present?
          if !@chat.chat_users.exists?(user_id: current_user.id)
            redirect_to chats_path
          end
        end
        #order by recent messages
        @chats = current_user.chats.left_joins(:chat_entries).where(chat_entries: { chat_type: 0}).group(:id).order(Arel.sql("MAX(chat_entries.created_at) DESC"))
      end
    end

end
