# frozen_string_literal: true

class CreateBoons < ActiveRecord::Migration[6.1]
  def change
    create_table :boons do |t|
      t.belongs_to :pone, null: false, foreign_key: true
      t.string     :granted_by, null: false
      t.string     :message_link
      t.integer    :points_count, null: false
      t.timestamp  :occurred_at, null: false
      t.timestamps default: -> { 'NOW()' }
    end
  end
end
