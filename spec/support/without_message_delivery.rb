# frozen_string_literal: true

RSpec.shared_context 'without message delivery' do
  around(:each) do |example|
    MessageBus.clear_subscribers
    example.run
  ensure
    MessageBus.load_subscribers
  end
end
