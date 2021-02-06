# frozen_string_literal: true

if defined?(Resque)
  require 'resque/tasks'

  namespace :resque do
    task setup: :environment do
      # Don't buffer logs to prevent losing messages during worker shutdown.
      $stdout.sync = true

      Resque.redis = ENV['REDIS_URL']

      Resque.before_fork do
        ActiveRecord::Base.connection.disconnect!
      end

      Resque.after_fork do
        ActiveRecord::Base.establish_connection
      end
    end
  end
end
