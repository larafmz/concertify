class ChatsController < ApplicationController

  before_action :set_params

  def index
  end

  def show
    #cant enter a chat if youre not assisting the event
    if @event && ( !Register.exists?(user_id: current_user&.id, event_id: @event.id) && !FutureAssistance.exists?(user_id: current_user&.id, event_id: @event.id) )
      redirect_to event_path(@event)
      return
    end
    @chat_entries = @chat.chat_entries if @chat
  end

  def send_message
    @chat = Chat.new(event_id: params[:event_id]) if !@chat.present?
    @chat.chat_users << ChatUser.new(user_id: params[:user_id]) if params[:user_id]

    if !@chat.chat_users.exists?(user_id: current_user.id)
      @chat.chat_users << ChatUser.new(user_id: current_user.id) 
      ChatEntry.create(chat_id: @chat.id, user_id: current_user.id, text: "entered_chat", chat_type: 1)
    end
    @chat.save!

    ChatEntry.create(chat_id: @chat.id, user_id: current_user.id, text: params[:message], chat_type: 0)
    redirect_back fallback_location: root_path
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
        end
        @chats = current_user.chats
      end
    end

end
