# frozen_string_literal: true

# == Schema Information
#
# Table name: pone_credentials
#
#  id         :bigint           not null, primary key
#  type       :string           not null
#  pone_id    :bigint           not null
#  data       :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_pone_credentials_on_pone_id  (pone_id)
#
# Foreign Keys
#
#  fk_rails_...  (pone_id => pones.id)
#
class PoneCredential < ApplicationRecord
  belongs_to :pone, inverse_of: :credentials

  validates :type, presence: true

  # @abstract
  # @return [Pone, nil]
  def authenticate(*)
    raise NotImplementedError, "#{self.class.name} does not implement `#{__method__}`."
  end
end
