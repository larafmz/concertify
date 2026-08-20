class ApplicationNotifier < Noticed::Event

    deliver_by :database

end
