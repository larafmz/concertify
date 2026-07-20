class InteractuablesController < ApplicationController

    def like
        existing_like = Like.find_by(interactuable_id: params[:id], user_id: current_user.id)
        if existing_like
            existing_like.destroy
        else
            existing_like = Like.create!(interactuable_id: params[:id], user_id: current_user.id)
        end
        redirect_back fallback_location: root_path
    end

    def comment
        Comment.create!(interactuable_id: params[:id], user_id: current_user.id, text: params[:text])
        redirect_to comments_interactuable_path(params[:id])
    end

    def likes
        @users = Interactuable.find(params[:id]).likes.map(&:user) 
        @interactuable = Interactuable.find(params[:id])
        @user = User.find(@interactuable.user_id)
    end

    def comments
        @comments = Interactuable.find(params[:id]).comments.order("created_at DESC")
        @interactuable = Interactuable.find(params[:id])
        @user = User.find(@interactuable.user_id)
    end

    def uncomment
        Comment.find(params[:comment_id]).destroy
        redirect_back fallback_location: root_path
    end

end