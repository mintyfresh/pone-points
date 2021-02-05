# frozen_string_literal: true

ActiveSupport::Notifications.subscribe('app.points.create') do |*, payload|
  AGoodPoneAchievementSubscriber.new(payload[:point]).perform
end

ActiveSupport::Notifications.subscribe('app.points.create') do |*, payload|
  SomeponeLikesYouAchievementSubscriber.new(payload[:point]).perform
end

ActiveSupport::Notifications.subscribe('app.points.create') do |*, payload|
  TheRegularAchievementSubscriber.new(payload[:point]).perform
end

ActiveSupport::Notifications.subscribe('app.points.create') do |*, payload|
  CounterpointAchievementSubscriber.new(payload[:point]).perform
end
