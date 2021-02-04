# frozen_string_literal: true

class CreatePoneCredentials < ActiveRecord::Migration[6.1]
  def change
    create_table :pone_credentials do |t|
      t.string     :type, null: false
      t.belongs_to :pone, null: false, foreign_key: true
      t.jsonb      :data, null: false, default: {}
      t.timestamps default: -> { 'NOW()' }
    end
  end
end
