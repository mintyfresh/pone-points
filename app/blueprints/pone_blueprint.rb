# frozen_string_literal: true

class PoneBlueprint < ApplicationBlueprint
  identifier :slug

  fields :name, :points_count

  field :created_at, name: :joined_at

  field :avatar_url do |pone|
    helpers.rails_blob_path(pone.avatar, only_path: true) if pone.avatar.attached?
  end

  field :links do |pone|
    {
      self:           helpers.api_v1_pone_path(pone, format: :json),
      page:           helpers.pone_path(pone),
      achievements:   helpers.api_v1_pone_achievements_path(pone, format: :json),
      points:         helpers.api_v1_pone_points_path(pone, format: :json),
      granted_points: helpers.granted_api_v1_pone_points_path(pone, format: :json),
      groups:         helpers.groups_api_v1_pone_path(pone, format: :json)
    }
  end

  view :me do
    fields :giftable_points_count, :daily_giftable_points_count, :bonus_points_count
  end
end
