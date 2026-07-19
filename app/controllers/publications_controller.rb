class PublicationsController < ApplicationController

    def index
        if params[:user_id]
            @user = User.find(params[:user_id])
            @publications = Publication.where(user_id: params[:user_id])
        elsif params[:concert_id]
            @concert = Concert.find(params[:concert_id])
            @publications = Publication.where(concert_id: params[:concert_id])
        elsif params[:artist_id]
            @artist = Artist.find(params[:artist_id])
            @publications = Publication.where(artist_id: params[:artist_id])
        end
        @publications = @publications.order("created_at DESC") if @publications
    end

    def new
        @publication = Publication.new
        render layout: false
    end

    def create
        @publication = Publication.new(create_params)
        @publication.save!
        redirect_to publications_path(user_id: current_user.id)
    end

    def destroy
      @publication = Publication.find(params[:id])
      @publication.destroy
      redirect_back fallback_location: root_path
    end
    
private

    def create_params
        params.require(:publication).permit(:type, :user_id, :artist_id, :concert_id, :review)
    end 

end