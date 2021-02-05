# frozen_string_literal: true

class CardFrameComponent < ApplicationComponent
  # @param title [String, nil]
  def initialize(title:)
    @title = title
  end
end
