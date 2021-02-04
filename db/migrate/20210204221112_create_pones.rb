# frozen_string_literal: true

class CreatePones < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'citext'

    create_table :pones do |t|
      t.citext     :name, null: false, index: { unique: true }
      t.string     :slug, null: false, index: { unique: true }
      t.string     :discord_id, null: false, index: { unique: true }
      t.integer    :points_count, null: false, default: 0
      t.integer    :daily_points_budget, null: false, default: 0
      t.timestamps default: -> { 'NOW()' }
    end
  end
end
