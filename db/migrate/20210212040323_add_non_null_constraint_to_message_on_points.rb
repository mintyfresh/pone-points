# frozen_string_literal: true

class AddNonNullConstraintToMessageOnPoints < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        execute(<<-SQL.squish)
          UPDATE
            points
          SET
            message = 'Boop!'
          WHERE
            points.message IS NULL OR points.message = ''
        SQL
      end
    end

    change_column_null :points, :message, false
  end
end
