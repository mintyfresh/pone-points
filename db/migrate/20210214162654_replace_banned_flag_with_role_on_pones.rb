# frozen_string_literal: true

class ReplaceBannedFlagWithRoleOnPones < ActiveRecord::Migration[6.1]
  def up
    execute(<<-SQL.squish)
      UPDATE
        pones
      SET
        roles = ARRAY['banned'::varchar] || pones.roles
      WHERE
        pones.banned
    SQL

    remove_column :pones, :banned
  end

  def down
    add_column :pones, :banned, :boolean, null: false, default: false

    execute(<<-SQL.squish)
      UPDATE
        pones
      SET
        banned = true,
        roles  = array_remove(pones.roles, 'banned')
      WHERE
        pones.roles @> ARRAY['banned'::varchar]
    SQL
  end
end
