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
FactoryBot.define do
  factory :pone_password_credential, class: 'PonePasswordCredential', parent: :pone_credential do
    type { 'PonePasswordCredential' }
    password { Faker::Internet.password }
  end
end
