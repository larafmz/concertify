class PublicationsController < ApplicationController
    
    load_and_authorize_resource

    def index
        publications = Publication.feed(current_user)
        @publications = Kaminari.paginate_array(publications).page(params[:page]).per(5)
        @pagination_path = request.query_parameters.merge( controller: "publications", action: "index" )
        respond_to do |format|
            format.html
            format.turbo_stream
        end
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
        publication_id = @publication.id
        if @publication.destroy
            respond_to do |format|
                format.turbo_stream { render turbo_stream: turbo_stream.remove("publication-#{publication_id}") }
                format.html { redirect_back fallback_location: root_path }
            end
        end
    end
    
private

    def create_params
        params.require(:publication).permit(:type, :user_id, :review, photos: [])
    end 

end