# frozen_string_literal: true

class AddBonusPointsToPones < ActiveRecord::Migration[6.1]
  def change
    change_table :pones, bulk: true do |t|
      t.integer :bonus_points, null: false, default: 0
      t.check_constraint 'bonus_points >= 0'
    end
  end
end
