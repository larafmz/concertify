namespace :notifications do
  desc "Check for upcoming events with future assistances and send notification"
  task upcoming_event: :environment do
    FutureAssistance.upcoming.each do |fa|
        Notification.create_for_upcoming_future_assistance(fa)
    end
  end

end
