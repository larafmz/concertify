class CommentsController < ApplicationController

  def show
    @comment = Comment.find(params[:id])
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

end
