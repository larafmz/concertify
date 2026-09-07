set :environment, "development"
set :output, "/home/larafmz/concertify/log/cron.log"

# WARNING:  Execute "whenever --update-crontab" everytime this file is changed !!!!!

every 1.day do 
  rake "notifications:upcoming_event"
end

