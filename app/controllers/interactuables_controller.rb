class InteractuablesController < ApplicationController
    
    load_and_authorize_resource

    before_action :set_interactuable, only: [:show, :comments, :reposts]

    def show
        @users = @interactuable.likes.map(&:user) #likes
    end

    def comments
        @comments = @interactuable.comments.viewables(current_user).order("created_at DESC").where(comment_father_id: nil) #comments
    end

    def reposts
        @users = @interactuable.reposts.map(&:user) #reposts
    end
        
    def destroy
        interactuable.destroy
        redirect_to registers_user_path(current_user)
    end

    def like
        existing_like = Like.find_by(interactuable_id: params[:id], user_id: current_user&.id)
        if existing_like
            existing_like.destroy
        else
            existing_like = Like.create!(interactuable_id: params[:id], user_id: current_user&.id)
        end
        redirect_back fallback_location: root_path
    end

    def repost
        existing_repost = Repost.find_by(interactuable_id: params[:id], user_id: current_user&.id)
        if existing_repost
            existing_repost.destroy
        else
            existing_repost = Repost.create!(interactuable_id: params[:id], user_id: current_user&.id)
        end
        redirect_back fallback_location: root_path
    end

    def comment
        Comment.create!(interactuable_id: params[:id], user_id: current_user&.id, text: params[:text])
        redirect_to comments_interactuable_path(params[:id])
    end

    def uncomment
        comment = Comment.find(params[:comment_id])
        path = father_link(comment)
        comment.destroy
        redirect_to path
    end

private
    
    def set_interactuable
        unless @interactuable
            flash[:alert] = t("not_found")
            redirect_back fallback_location: root_path
            return
        end
        @user = User.find(@interactuable.user_id)
        @liked_by_creator = Interactuable.where(id: @user.likes.for_event(@interactuable.event_id).pluck(:interactuable_id))
    end

    
end