class NotificationsController < ApplicationController

    def index
        @notifications = current_user.notifications.order(created_at: :desc)
    end

    def mark_as_read
        @notification = Notification.find(params[:id])
        @notification.mark_as_read 
        respond_to do |format|
            format.json { head :no_content }
            format.js {}
        end
    end

end