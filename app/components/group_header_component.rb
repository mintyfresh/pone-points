# frozen_string_literal: true

class GroupHeaderComponent < ApplicationComponent
  # @param group [Group]
  def initialize(group:)
    @group = group
  end

  def scaled_group_image
    @group.image.variant(resize_to_fill: [150, 150])
  end
end
