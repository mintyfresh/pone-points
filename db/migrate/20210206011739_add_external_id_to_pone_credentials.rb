# frozen_string_literal: true

class AddExternalIdToPoneCredentials < ActiveRecord::Migration[6.1]
  def change
    change_table :pone_credentials, bulk: true do |t|
      t.string :external_id

      t.index %i[type pone_id], unique: true
      t.index %i[type external_id], unique: true
    end
  end
end
