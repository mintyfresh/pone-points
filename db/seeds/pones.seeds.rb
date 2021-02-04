# frozen_string_literal: true

Pone.find_or_create_by!(name: 'Starf') do |pone|
  pone.discord_id = 'Starfflame#0815'

  pone.boons.build(
    granted_by:   'Minty Fresh',
    message_link: 'https://discord.com/channels/140359933341204481/140359933341204481/807008644817485854',
    reason:       'For being spoiled, good and proper.',
    points_count: 2,
    occurred_at:  '2020-02-04 17:04:00 +0500'
  )
end
