# frozen_string_literal: true

class PoneBlueprint < ApplicationBlueprint
  identifier :slug

  fields :name, :points_count

  field :created_at, name: :joined_at

  field :links do |pone|
    {
      self:         helpers.api_v1_pone_path(pone, format: :json),
      page:         helpers.pone_path(pone, format: :json),
      achievements: helpers.api_v1_pone_achievements_path(pone, format: :json),
      points:       helpers.api_v1_pone_points_path(pone, format: :json)
    }
  end
end
