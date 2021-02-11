# frozen-string_literal: true

class AddGiftablePointsCountToPones < ActiveRecord::Migration[6.1]
  def change
    change_table :pones, bulk: true do |t|
      t.rename :bonus_points, :bonus_points_count

      t.integer :giftable_points_count, null: false, default: 0

      t.check_constraint 'points_count >= 0'
      t.check_constraint 'giftable_points_count >= 0'
      t.check_constraint 'daily_giftable_points_count >= 0'
    end

    reversible do |dir|
      dir.up do
        execute(<<-SQL.squish)
          UPDATE
            pones
          SET
            giftable_points_count = GREATEST(0, daily_giftable_points_count - (
              SELECT SUM(points.count) FROM points WHERE points.granted_by_id = pones.id AND points.created_at >= CURRENT_DATE
            ))
        SQL
      end
    end
  end
end
