class PublicationsController < ApplicationController

    def index
        @user = User.find(params[:user_id])
        @publications = Publication.where(user_id: params[:user_id])
    end
    

end