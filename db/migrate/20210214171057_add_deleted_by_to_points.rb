# frozen_string_literal: true

class AddDeletedByToPoints < ActiveRecord::Migration[6.1]
  def change
    add_reference :points, :deleted_by, null: true, foreign_key: { to_table: :pones }
  end
end
