# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreatePointForm, type: :form do
  subject(:form) { described_class.new(**input, pone: pone, granted_by: granted_by) }

  let(:input) { attributes_for(:create_point_input) }
  let(:pone) { create(:pone) }
  let(:granted_by) { create(:pone, :verified) }

  it 'has a valid input factory' do
    expect(form).to be_valid
  end

  it 'is invalid without a count' do
    input[:count] = nil
    expect(form).to be_invalid
  end

  it 'is invalid when the count is zero' do
    input[:count] = 0
    expect(form).to be_invalid
  end

  it 'is invalid when the count is negative' do
    input[:count] = -1
    expect(form).to be_invalid
  end

  it 'is invalid when the count is greater than 3' do
    input[:count] = 4
    expect(form).to be_invalid
  end

  it 'is invalid without a message' do
    input[:message] = nil
    expect(form).to be_invalid
  end

  it 'is invalid when the message is too long' do
    input[:message] = 'a' * 1001
    expect(form).to be_invalid
  end

  describe '#perform' do
    subject(:perform) { form.perform }

    it 'returns the newly created point' do
      expect(perform).to be_a(Point)
        .and be_persisted
        .and have_attributes(pone: pone, granted_by: granted_by)
    end

    it 'stores the input count and message on the point' do
      expect(perform).to have_attributes(
        count:   input[:count],
        message: input[:message]
      )
    end

    it "increases the recipient's points count by the input count" do
      expect { perform }.to change { pone.points_count }.by(input[:count])
    end

    context 'when the pone granting the point does not have enough daily point budget' do
      let(:granted_by) { create(:pone, daily_giftable_points_count: 0) }

      it 'returns false' do
        expect(perform).to be(false)
      end

      it 'sets an error indicating insufficient points budget' do
        perform
        expect(form.errors).to be_added(:base, :not_enough_points, remaining: 0)
      end
    end
  end
end
