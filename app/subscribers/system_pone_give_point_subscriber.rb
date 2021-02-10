# frozen_string_literal: true

class SystemPoneGivePointSubscriber < ApplicationSubscriber
  subscribe_to 'app.pones.verify'

  payload_field :pone

  def perform
    pone.points.find_or_create_by!(
      granted_by: system_pone,
      count:      1,
      message:    'For being a good, verified pone, of course!'
    )
  end

private

  # @return [Pone]
  def system_pone
    @system_pone ||= Pone.find_by!(name: 'System Pone')
  end
end
