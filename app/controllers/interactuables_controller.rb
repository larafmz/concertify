class InteractuablesController < ApplicationController

    def show
        @users = Interactuable.find(params[:id]).likes.map(&:user) 
        @interactuable = Interactuable.find(params[:id])
        @user = User.find(@interactuable.user_id)
    end

    def like
        existing_like = Like.find_by(interactuable_id: params[:id], user_id: current_user.id)
        if existing_like
            existing_like.destroy
        else
            existing_like = Like.create!(interactuable_id: params[:id], user_id: current_user.id)
        end
        redirect_back fallback_location: root_path
    end

    def repost
        existing_repost = Repost.find_by(interactuable_id: params[:id], user_id: current_user.id)
        if existing_repost
            existing_repost.destroy
        else
            existing_repost = Repost.create!(interactuable_id: params[:id], user_id: current_user.id)
        end
        redirect_back fallback_location: root_path
    end

    def comment
        Comment.create!(interactuable_id: params[:id], user_id: current_user.id, text: params[:text])
        redirect_to comments_interactuable_path(params[:id])
    end

    def uncomment
        Comment.find(params[:comment_id]).destroy
        redirect_back fallback_location: root_path
    end

    def comments
        @comments = Interactuable.find(params[:id]).comments.order("created_at DESC")
        @interactuable = Interactuable.find(params[:id])
        @user = User.find(@interactuable.user_id)
    end

    def reposts
        @users = Interactuable.find(params[:id]).reposts.map(&:user) 
        @interactuable = Interactuable.find(params[:id])
        @user = User.find(@interactuable.user_id)
    end
    
end