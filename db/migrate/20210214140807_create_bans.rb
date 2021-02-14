# frozen_string_literal: true

class CreateBans < ActiveRecord::Migration[6.1]
  def change
    create_table :bans do |t|
      t.belongs_to :pone, null: false, foreign_key: true
      t.belongs_to :issuer, null: false, foreign_key: { to_table: :pones }
      t.string     :reason, null: false
      t.timestamp  :expires_at
      t.timestamp  :revoked_at
      t.timestamps default: -> { 'NOW()' }
    end
  end
end
