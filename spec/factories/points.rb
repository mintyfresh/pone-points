# frozen_string_literal: true

# == Schema Information
#
# Table name: points
#
#  id            :bigint           not null, primary key
#  pone_id       :bigint           not null
#  granted_by_id :bigint           not null
#  message       :string           not null
#  count         :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  deleted_at    :datetime
#
# Indexes
#
#  index_points_on_granted_by_id  (granted_by_id)
#  index_points_on_pone_id        (pone_id)
#
# Foreign Keys
#
#  fk_rails_...  (granted_by_id => pones.id)
#  fk_rails_...  (pone_id => pones.id)
#
FactoryBot.define do
  factory :point do
    association :pone, strategy: :build
    association :granted_by, factory: :pone, strategy: :build

    message { Faker::Hipster.sentence }
    count { rand(1..3) }
  end
end
