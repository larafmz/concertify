class CommentsController < ApplicationController
  
  load_and_authorize_resource

  before_action :not_found

  def show
    @interactuable = @comment.interactuable
    @user = @comment.user
    @replies = @comment.replies.order("created_at DESC")
  end
  
  def reply
    @comment.reply(current_user&.id, params[:text])
    redirect_to comment_path(@comment)
  end

private

  def not_found
    unless @comment
      flash[:alert] = t("not_found_masc", model: Comment.singular.downcase)
      redirect_back fallback_location: root_path
      return
    end
  end

end
