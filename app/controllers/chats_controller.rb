class ChatsController < ApplicationController

  before_action :set_params

  def index
  end

  def show
    @messages = @chat.messages if @chat
  end

  def send_message
    @chat = Chat.new(event_id: params[:event_id]) if !@chat.present?
    @chat.chat_users << ChatUser.new(user_id: params[:user_id]) if params[:user_id]
    @chat.chat_users << ChatUser.new(user_id: current_user.id) if !@chat.chat_users.exists?(user_id: current_user.id)
    @chat.save!

    Message.create(chat_id: @chat.id, user_id: current_user.id, text: params[:message])
    redirect_back fallback_location: root_path
  end

  def exit
    ChatUser.destroy_by(user_id: params[:user_id], chat_id: params[:id])
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
        end
        @chats = current_user.chats
      end
    end

end
