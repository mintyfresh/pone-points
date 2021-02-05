# frozen_string_literal: true

ActiveSupport::Notifications.subscribe('app.boons.create') do |*, payload|
  AGoodPoneAchievementSubscriber.new(payload[:boon]).perform
end

ActiveSupport::Notifications.subscribe('app.boons.create') do |*, payload|
  SomeponeLikesYouAchievementSubscriber.new(payload[:boon]).perform
end

ActiveSupport::Notifications.subscribe('app.boons.create') do |*, payload|
  TheRegularAchievementSubscriber.new(payload[:boon]).perform
end

ActiveSupport::Notifications.subscribe('app.boons.create') do |*, payload|
  CounterpointAchievementSubscriber.new(payload[:boon]).perform
end
