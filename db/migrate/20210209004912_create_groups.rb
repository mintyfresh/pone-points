# frozen_string_literal: true

class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.belongs_to :owner, null: false, foreign_key: { to_table: :pones }
      t.citext     :name, null: false, index: { unique: true }
      t.string     :slug, null: false, index: { unique: true }
      t.string     :description
      t.integer    :members_count, null: false, default: 0
      t.timestamps default: -> { 'NOW()' }
    end
  end
end
