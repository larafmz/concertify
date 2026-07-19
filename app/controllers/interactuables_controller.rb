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

    def likes
        @users = Interactuable.find(params[:id]).likes.map(&:user) 
        @interactuable = Interactuable.find(params[:id])
        @user = User.find(@interactuable.user_id)
    end

    def comments
        @users = Interactuable.find(params[:id]).comments.map(&:user) 
        @interactuable = Interactuable.find(params[:id])
        @user = User.find(@interactuable.user_id)
    end

end