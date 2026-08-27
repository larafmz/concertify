class NotificationsController < ApplicationController

    load_and_authorize_resource

    def mark_as_read
        @notification.mark_as_read 
        respond_to do |format|
            format.json { head :no_content }
            format.js {}
        end
    end

    def read_and_redirect
        @notification.mark_as_read 
        redirect_to @notification.path
    end

    def mark_all_read
        User.find(params[:user_id]).notifications.mark_as_read 
        redirect_back fallback_location: root_path
    end

end