# frozen_string_literal: true

Pone.find_or_create_by!(name: 'Minty Fresh')
Pone.find_or_create_by!(name: 'Bytewave')

Pone.find_or_create_by!(name: 'Starf') do |pone|
  pone.boons.build(
    granted_by:   Pone.find_by!(name: 'Minty Fresh'),
    reason:       'For being spoiled, good and proper.',
    points_count: 2,
    created_at:   '2020-02-04 17:04:00 +0500'
  )
end
