class CommentsController < ApplicationController
  
  authorize_resource

  before_action :set_comment

  def show
    @interactuable = @comment.interactuable
    @user = @comment.user
    @replies = @comment.replies.order("created_at DESC")
  end
  
  def reply
    father = Comment.find(params[:father_id])
      Comment.create!(
        interactuable_id: father.interactuable_id, 
        user_id: current_user&.id, 
        text: params[:text],
        comment_father_id: father.id)
      redirect_to comment_path(father.id)
  end

private

  def set_comment
    @comment = Comment.find_by(id: params[:id])
    unless @comment
      flash[:alert] = t("not_found_masc", model: Comment.singular.downcase)
      redirect_back fallback_location: root_path
      return
    end
  end

end
