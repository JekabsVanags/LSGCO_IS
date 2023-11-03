env :PATH, ENV["PATH"]
set :output, "log/cron_log.log"

# Schedule the job to run every 1 second
every 1.month do
  runner "MembershipFeeJob.perform_now"
end
