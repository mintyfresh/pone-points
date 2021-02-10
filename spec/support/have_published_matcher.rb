# frozen_string_literal: true

RSpec::Matchers.define :have_published do |message|
  match do |block|
    @payloads    = []
    subscription = ActiveSupport::Notifications.subscribe(message) do |*, payload|
      @payloads << payload
    end

    block.call

    @actual_count = @payloads.count { |payload| satisfy?(payload) }

    @count ? @actual_count == @count : @actual_count.positive?
  ensure
    ActiveSupport::Notifications.unsubscribe(subscription)
  end

  def supports_block_expectations?
    true
  end

  chain :once do
    @count = 1
  end

  chain :times do |count|
    @count = count
  end

  chain :with do |expected_payload|
    @expected_payload = expected_payload
  end

  def satisfy?(payload)
    return true unless defined?(@expected_payload)

    payload == @expected_payload || @expected_payload === payload # rubocop:disable Style/CaseEquality
  end
end
