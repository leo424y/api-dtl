#
# config/initializers/scheduler.rb

require 'rufus-scheduler'

# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.singleton

if Rails.env != 'development'
  s.every '1m' do
    begin
      Crowdtangle.ct_api_import 
    rescue => exception
      p exception
    end
  end

  s.every '10m' do
    begin
      Gene.news_api_import
    rescue => exception
      p exception
    end
  end
end

if Rails.env == 'development'
  s.every '1m' do
    begin
      # Gene.news_api_import
    rescue => exception
      p exception
    end
  end
end
