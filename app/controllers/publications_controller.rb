class PublicationsController < ApplicationController
    
    load_and_authorize_resource

    def index
        @publications = Publication.all.order("created_at DESC") 
    end

    def new
        @publication = Publication.new
        render layout: false
    end

    def create
        @publication = Publication.new(create_params)
        @publication.save!
        redirect_to publications_path(user_id: current_user&.id)
    end

    def destroy
        @publication = Publication.find(params[:id])
        user = @publication.user
        @publication.destroy
        if request.referer == interactuable_url(@publication)
            redirect_to publications_path(user_id: user.id)
        else
            redirect_back fallback_location: publications_path(user_id: user.id)
        end
    end
    
private

    def create_params
        params.require(:publication).permit(:type, :user_id, :review)
    end 

end