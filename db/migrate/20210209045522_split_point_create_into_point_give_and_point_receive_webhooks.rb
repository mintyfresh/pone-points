# frozen_string_literal: true

class SplitPointCreateIntoPointGiveAndPointReceiveWebhooks < ActiveRecord::Migration[6.1]
  def up
    execute(<<-SQL.squish)
      UPDATE
        webhooks
      SET
        events = array_remove(events, 'app.points.create') || ARRAY['app.points.give', 'app.points.receive']::varchar[]
      WHERE
        'app.points.create' = ANY(events)
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
