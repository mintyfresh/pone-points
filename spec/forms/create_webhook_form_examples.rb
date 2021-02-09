# frozen_string_literal: true

RSpec.shared_examples_for CreateWebhookForm, type: :form do
  it 'is invalid without a name' do
    input[:name] = nil
    expect(form).to be_invalid
  end

  it 'is invalid when the name is too long' do
    input[:name] = 'a' * (Webhook::NAME_MAX_LENGTH + 1)
    expect(form).to be_invalid
  end

  it 'is invalid without a URL' do
    input[:url] = nil
    expect(form).to be_invalid
  end

  it 'is invalid when the URL is malformed' do
    input[:url] = 'fake-url'
    expect(form).to be_invalid
  end

  it 'is invalid when the URL scheme is unsupported' do
    input[:url] = 'data://foo'
    expect(form).to be_invalid
  end

  it 'is invalid when the URL does not have a host' do
    input[:url] = 'https://'
    expect(form).to be_invalid
  end

  it 'is invalid when the events list is nil' do
    input[:events] = nil
    expect(form).to be_invalid
  end

  it 'is valid without any events' do
    input[:events] = []
    expect(form).to be_valid
  end

  it 'is invalid when the events list contains unsupported values' do
    input[:events] = ['fake-event']
    expect(form).to be_invalid
  end
end
