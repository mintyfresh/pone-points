# frozen_string_literal: true

class CardFrameComponent < ApplicationComponent
  # @param title [String, nil]
  # @param sm [Integer]
  # @param md [Integer]
  # @param lg [Integer]
  # @param xl [Integer]
  def initialize(title:, sm: 12, md: 8, lg: 6, xl: 4)
    @title = title
    @sm    = sm
    @md    = md
    @lg    = lg
    @xl    = xl
  end

  # @return [String]
  def alignment_class
    fragments = []

    %w[sm md lg xl].each do |size|
      fragments << col_class(size)
      fragments << offset_class(size)
    end

    fragments.compact.join(' ')
  end

  # @param size [String]
  # @return [String]
  def col_class(size)
    "col-#{size}-#{instance_variable_get(:"@#{size}")}"
  end

  # @param size [String]
  # @return [String, nil]
  def offset_class(size)
    (offset = offset_for_size(instance_variable_get(:"@#{size}"))).nonzero? && "offset-#{size}-#{offset}"
  end

private

  # @param cols [Integer]
  # @return [Integer]
  def offset_for_size(cols)
    (12 - cols) / 2
  end
end
