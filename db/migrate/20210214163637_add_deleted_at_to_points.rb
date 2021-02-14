# frozen_string_literal: true

class AddDeletedAtToPoints < ActiveRecord::Migration[6.1]
  def change
    add_column :points, :deleted_at, :timestamp
  end
end
