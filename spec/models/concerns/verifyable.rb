# frozen_string_literal: true

RSpec.shared_examples_for Verifyable, type: :concern do
  it 'is not verified by default' do
    expect(subject).not_to be_verified
  end

  it 'is verified when a verified-at timestamp is set' do
    subject.verified_at = Time.current
    expect(subject).to be_verified
  end

  it 'publishes a message when verified' do
    freeze_time do
      expect { subject.verified! }.to have_published("app.#{subject.model_name.plural}.verify")
        .with(subject.model_name.singular.to_sym => subject, occurred_at: Time.current)
        .once
    end
  end
end
