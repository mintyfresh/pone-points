# frozen_string_literal: true

class CreateWebhooks < ActiveRecord::Migration[6.1]
  def change
    create_table :webhooks do |t|
      t.belongs_to :pone, null: false, foreign_key: true
      t.string     :name, null: false
      t.string     :signing_key, null: false
      t.string     :events, array: true, null: false
      t.string     :url, null: false
      t.timestamps default: -> { 'NOW()' }
    end
  end
end
