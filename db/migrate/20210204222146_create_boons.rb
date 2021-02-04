# frozen_string_literal: true

class CreateBoons < ActiveRecord::Migration[6.1]
  def change
    create_table :boons do |t|
      t.belongs_to :pone, null: false, foreign_key: true
      t.belongs_to :granted_by, null: false, foreign_key: { to_table: :pones }
      t.string     :reason
      t.integer    :points_count, null: false
      t.timestamps default: -> { 'NOW()' }
    end
  end
end
