class NotificationsController < ApplicationController

    load_and_authorize_resource

    def mark_as_read
        @notification.mark_as_read #method included in Noticed gem
        respond_to do |format|
        format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
                "notification-#{@notification.id}",
                partial: "notifications/index_item",
                locals: { notification: @notification }
            )
            end
        format.html { redirect_to notifications_user_path }
        end
    end

    def read_and_redirect
        @notification.mark_as_read 
        redirect_to @notification.path
    end

    def mark_all_read
        User.find(params[:user_id]).notifications.mark_as_read 
        redirect_to notifications_user_path(current_user)
    end

end