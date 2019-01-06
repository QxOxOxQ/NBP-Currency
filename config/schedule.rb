# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
set :chronic_options, hours24: true

every 1.day, at: '7:30' do
  runner "PeriodicSaveNBPCurrenciesJob.perform_later"
end