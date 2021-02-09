# frozen_string_literal: true

class GroupBlueprint < ApplicationBlueprint
  identifier :slug

  fields :name, :created_at

  field :links do |group|
    {
      self:    helpers.api_v1_group_path(group, format: :json),
      page:    helpers.group_path(group),
      owner:   helpers.api_v1_pone_path(group.owner, format: :json),
      members: helpers.members_api_v1_group_path(group, format: :json)
    }
  end

  view :detail do
    fields :description
  end
end
