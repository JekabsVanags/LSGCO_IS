env :PATH, ENV["PATH"]
env :DISPLAY, ":0"
set :output, "log/cron_log.log"

# Schedule the job to run every  month
every 10.minutes do
  runner "MembershipFeeJob.perform_now"
end
