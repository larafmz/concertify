class ChatsController < ApplicationController

  load_and_authorize_resource

  before_action :authenticate_user
  before_action :set_chat 

  def index
  end

  def show
    unless @chat
      redirect_to chats_path
      return
    end
    @chat_entries = @chat.chat_entries.order("created_at ASC") if @chat
    @chat_user.mark_as_read
  end

  def send_message
    message = ChatEntry.create(chat_id: @chat.id, user_id: current_user.id, text: params[:message], chat_type: 0)
    render json: {}, status: :no_content #rendering nothing
  end

  def exit
    ChatUser.destroy_by(user_id: params[:user_id], chat_id: params[:id])
    ChatEntry.create(chat_id: params[:id], user_id: params[:user_id], text: "exited_chat", chat_type: 1)
    redirect_to chats_path
  end

  def read
    @chat_user.mark_as_read
    render json: {}, status: :no_content #rendering nothing
  end

  private 

    def authenticate_user
      unless current_user.present?
        redirect_back fallback_location: root_path
        return
      end
    end

    def set_chat
      if params[:user_id]
        @user = User.find(params[:user_id])
        @chat = Chat.by_users(current_user.id, @user.id).first
        @chat = Chat.create_private_chat(current_user.id, @user.id) unless @chat
      elsif params[:event_id]
        @event = Event.find(params[:event_id])
        @chat = Chat.create_event_chat(params[:event_id], current_user.id)
      elsif params[:id] && Chat.exists?(params[:id])
        @chat = Chat.find(params[:id])
        @event = @chat.event if @chat.group_chat?
        @user = @chat.other_user(current_user) unless @chat.group_chat?
        unless @chat.chat_users.exists?(user_id: current_user.id)
          redirect_to chats_path
        end
      end
      @chat_user = @chat.chat_users.find_by(user_id: current_user.id) if @chat
      @chats = current_user.chats
    end

end
