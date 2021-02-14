# frozen_string_literal: true

class AddBannedToPones < ActiveRecord::Migration[6.1]
  def change
    add_column :pones, :banned, :boolean, null: false, default: false
  end
end
