class NewMessageNotifier < ApplicationNotifier
  deliver_by :database

  notification_methods do
    def message
      "#{params[:sender].name} te ha enviado un mensaje"
    end

    def url
      chat_path(params[:chat])
    end
  end
  
end