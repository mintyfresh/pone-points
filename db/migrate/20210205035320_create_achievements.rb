# frozen_string_literal: true

class CreateAchievements < ActiveRecord::Migration[6.1]
  def change
    create_table :achievements do |t|
      t.string     :name, null: false, index: { unique: true }
      t.string     :description, null: false
      t.integer    :pones_count, null: false, default: 0
      t.timestamps default: -> { 'NOW()' }
    end
  end
end
