# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Currency, type: :model do
  describe 'validations' do
    it { is_expected.to validate_length_of(:name).is_equal_to(3) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:rate) }
  end

  describe 'active record' do
    it { is_expected.to belong_to(:day) }

    it 'when is day with currency will not creates another' do
      day =  create(:day)
      currency = create(:currency, name: 'EUR', day: day)
      aggregate_failures do
        expect(currency).to be_valid
        expect(build(:currency, name: 'EUR', day: day)).not_to be_valid
      end
    end
  end
end
