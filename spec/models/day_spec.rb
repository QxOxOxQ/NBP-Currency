# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Day, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:date) }
  end

  describe 'active record' do
    it { is_expected.to have_many(:currencies) }
  end
end
