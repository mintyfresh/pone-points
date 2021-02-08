# frozen_string_literal: true

def webhook(locator, **options)
  subscribe("webhooks/#{locator}_webhook", **options)
end

webhook :point_create, on: 'app.points.create'

with_options on: 'app.points.create' do
  subscribe :a_good_pone_achievement
  subscribe :counterpoint_achievement
  subscribe :somepone_likes_you_achievement
  subscribe :the_regular_achievement
end
