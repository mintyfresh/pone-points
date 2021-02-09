# frozen_string_literal: true

class CreateMemberships < ActiveRecord::Migration[6.1]
  def change
    create_table :memberships do |t|
      t.belongs_to :group, null: false, foreign_key: true
      t.belongs_to :member, null: false, foreign_key: { to_table: :pones }
      t.timestamps default: -> { 'NOW()' }

      t.index %i[group_id member_id], unique: true
    end
  end
end
