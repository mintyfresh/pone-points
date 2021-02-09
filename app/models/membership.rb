# frozen_string_literal: true

# == Schema Information
#
# Table name: memberships
#
#  id         :bigint           not null, primary key
#  group_id   :bigint           not null
#  member_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_memberships_on_group_id                (group_id)
#  index_memberships_on_group_id_and_member_id  (group_id,member_id) UNIQUE
#  index_memberships_on_member_id               (member_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (member_id => pones.id)
#
class Membership < ApplicationRecord
  belongs_to :group, counter_cache: :members_count, inverse_of: :memberships
  belongs_to :member, class_name: 'Pone', inverse_of: :memberships
end
