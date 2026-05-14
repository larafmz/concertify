class ArtistsController < ApplicationController

  load_and_authorize_resource

  private

    def artist_params
      keys = [:name]
      params.require(:artist).permit(keys)
    end

end