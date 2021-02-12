# frozen_string_literal: true

class PointBlueprint < ApplicationBlueprint
  identifier :id

  fields :message, :message_html, :count

  field :created_at, name: :granted_at

  field :links do |point|
    {
      self:       helpers.api_v1_pone_point_path(point.pone, point, format: :json),
      pone:       helpers.api_v1_pone_path(point.pone, format: :json),
      granted_by: helpers.api_v1_pone_path(point.granted_by, format: :json)
    }
  end
end
