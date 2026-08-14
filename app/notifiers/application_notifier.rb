class ApplicationNotifier < Noticed::Event

    deliver_by :database

    param :message

    notification_methods do
        def message
            params[:message]
        end
    end

end
