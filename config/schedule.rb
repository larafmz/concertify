set :environment, "development"
set :output, "/home/larafmz/concertify/log/cron.log"

every 1.day do
  rake "notifications:upcoming_event"
end

