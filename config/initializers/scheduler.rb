#
# config/initializers/scheduler.rb

require 'rufus-scheduler'

# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.singleton

s.every '13m' do
  begin
    Crowdtangle.ct_api_import
  rescue => error
    p error
  end
end 