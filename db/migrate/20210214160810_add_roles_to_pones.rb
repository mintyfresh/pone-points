# frozen_string_literal: true

class AddRolesToPones < ActiveRecord::Migration[6.1]
  def change
    add_column :pones, :roles, :string, array: true, null: false, default: []
  end
end
