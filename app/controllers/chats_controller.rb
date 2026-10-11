class ChatsController < ApplicationController

  include ApplicationHelper

  load_and_authorize_resource
  before_action :set_params, only: [:index, :show, :members]

  def index
  end

  def create
    if params[:user_id]
      @user = User.find_by(id: params[:user_id])
      unless @user
        flash[:alert] = t("messages.error")
        redirect_to chats_path
        return
      end
      @chat = Chat.by_users(current_user.id, @user.id).first
      @chat = Chat.create_private_chat(current_user.id, @user.id) unless @chat
    elsif params[:event_id]
      @chat = Chat.create_or_add_user_to_event_chat(params[:event_id], current_user.id)
    end 
    if !@chat || !@chat.persisted?
      flash[:alert] = t("messages.error")
      redirect_to chats_path
      return
    end
    redirect_to chat_path(@chat)
  end

  def show
    unless @chat
      flash[:alert] = t("not_found_masc", model: Chat.singular.downcase)
      redirect_to chats_path
      return
    else
      @event = Event.find(@chat.event_id) if @chat.group_chat?
      @user = @chat.other_user(current_user) unless @chat.group_chat?
      
      @chat_user&.mark_as_read

      @chat_entries = @chat.chat_entries.order("created_at DESC").page(params[:page]).per(20)
      @pagination_path = chat_path(@chat, request.query_parameters)
      respond_to do |format|
          format.html
          format.turbo_stream
      end
    end

  end

  def send_message
    @chat.send_message(current_user.id, params[:message])
    render json: {}, status: :no_content #rendering nothing
  end

  def exit
    Chat.find(params[:id]).exit_chat(params[:user_id])
    redirect_to chats_path
  end

  def mark_as_read #used in javascript chat_controller.js
    @chat_user.mark_as_read
    render json: {}, status: :no_content #rendering nothing
  end
  
  def members
    unless @chat.group_chat? 
      flash[:alert] = t("messages.error")
      redirect_to chats_path
      return
    end

    @pagination_path = members_chat_path(@chat, request.query_parameters)
    @event = @chat.event
    event_date_status = @event.past_or_future
    users = @chat.users
    @users = users.page(params[:page]).per(20)
    if event_date_status == "future"
      @future_assistances = @event.future_assistances.includes(:user).where(user_id: @users.pluck(:id)).page(params[:page]).per(10)
    end
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private 

    def set_params
      @chat_user = @chat.chat_users.find_by(user_id: current_user.id) if @chat
      @chats = current_user.chats.order_by_recent_messages.includes(:event, :chat_users, :users)
    end

end
