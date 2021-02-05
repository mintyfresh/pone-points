# frozen_string_literal: true

class CreateUnlockedAchievements < ActiveRecord::Migration[6.1]
  def change
    create_table :unlocked_achievements do |t|
      t.belongs_to :pone, null: false, foreign_key: true
      t.belongs_to :achievement, null: false, foreign_key: true
      t.timestamps default: -> { 'NOW()' }

      t.index %i[pone_id achievement_id], unique: true
    end
  end
end
