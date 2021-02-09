# frozen_string_literal: true

class GroupBlueprint < ApplicationBlueprint
  identifier :slug

  fields :name, :created_at

  field :links do |pone|
    {
      page: helpers.group_path(pone)
    }
  end
end
