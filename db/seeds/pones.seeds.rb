# frozen_string_literal: true

Pone.find_or_create_by!(name: 'Minty Fresh') do |pone|
  pone.discord_id = 'Minty Fresh#0110'
end

Pone.find_or_create_by!(name: 'Starf') do |pone|
  pone.discord_id = 'Starfflame#0815'

  pone.boons.build(
    granted_by:   Pone.find_by!(name: 'Minty Fresh'),
    reason:       'For being spoiled, good and proper.',
    points_count: 2,
    created_at:   '2020-02-04 17:04:00 +0500'
  )
end

Pone.find_or_create_by!(name: 'Bytewave') do |pone|
  pone.discord_id = 'Bytewave#8086'
end
