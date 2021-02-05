# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  extend HasUniqueAttribute

  self.abstract_class = true
end
