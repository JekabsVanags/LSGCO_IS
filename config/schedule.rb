env :PATH, ENV["PATH"]
set :output, "log/cron_log.log"

# Schedule the job to run every  month
every 1.minute do
  runner "MembershipFeeJob.perform_now"
end
