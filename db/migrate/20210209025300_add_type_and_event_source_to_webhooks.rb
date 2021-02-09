# frozen_string_literal: true

class AddTypeAndEventSourceToWebhooks < ActiveRecord::Migration[6.1]
  def change
    change_table :webhooks, bulk: true do |t|
      t.string     :type, null: true
      t.belongs_to :event_source, polymorphic: true, null: true
      t.rename     :pone_id, :owner_id
    end

    reversible do |dir|
      dir.up do
        execute(<<-SQL.squish)
          UPDATE
            webhooks
          SET
            type              = 'PoneWebhook',
            event_source_id   = owner_id,
            event_source_type = 'Pone'
        SQL

        change_column_null :webhooks, :type, false
        change_column_null :webhooks, :event_source_id, false
        change_column_null :webhooks, :event_source_type, false
      end
    end
  end
end
