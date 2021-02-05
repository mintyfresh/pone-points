# frozen_string_literal: true

class RenameBoonsToPoints < ActiveRecord::Migration[6.1]
  def change
    rename_table :boons, :points

    change_table :points, bulk: true do |t|
      t.rename :points_count, :count
      t.rename :reason, :message
    end
  end
end
