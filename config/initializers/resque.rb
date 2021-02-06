# frozen_string_literal: true

if defined?(Resque)
  Resque.redis = ENV['REDIS_URL']

  Resque.before_fork do
    ActiveRecord::Base.connection.disconnect!
  end

  Resque.after_fork do
    ActiveRecord::Base.establish_connection
  end
end
