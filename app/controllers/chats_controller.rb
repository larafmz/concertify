class ChatsController < ApplicationController

  def index
    @chats = current_user.chats
  end

  def show
    if params[:user_id]
      @user = User.find(params[:user_id])
      @chat = Chat.by_users(current_user.id, @user.id).first
    elsif params[:id]
      @chat = Chat.find(params[:id])
      @user = @chat.other_user(current_user)
    end
    @chats = current_user.chats
    @messages = @chat.messages if @chat
  end

  def send_message
    if params[:user_id]
      @chat = Chat.by_users(current_user.id, params[:user_id]).first 
      if !@chat.present?
        @chat = Chat.new
        @chat.chat_users << ChatUser.new(user_id: current_user.id)
        @chat.chat_users << ChatUser.new(user_id: params[:user_id])
        @chat.save!
      end
    elsif params[:id] #chat directo

    else
      #TO/DO error
      puts "ERRORRR"
    end
    Message.create(chat_id: @chat.id, user_id: current_user.id, text: params[:message])
    redirect_back fallback_location: root_path

  end

end
