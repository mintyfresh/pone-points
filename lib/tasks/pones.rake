# frozen_string_literal: true

namespace :pones do
  task refresh_giftable_points_count: :environment do
    Pone.update_all(<<-SQL.squish) # rubocop:disable Rails/SkipsModelValidations
      "updated_at"            = now(),
      "giftable_points_count" = "pones"."daily_giftable_points_count"
    SQL
  end
end
