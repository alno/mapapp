# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, {:error => File.expand_path(File.dirname(__FILE__) + '/../log/cron-error.log'), :standard => File.expand_path(File.dirname(__FILE__) + '/../log/cron.log')}

every 3.days, :at => '01:30' do
  rake "osm:update"
end
