# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::NbpCurrenciesController, type: :request do
  let!(:usd_currencies) { create_list(:currency, 3, name: 'USD') }
  let!(:empty_day) do
    create(:day, date: Day.order(date: :asc).first.date.yesterday,
                 lack_of_currency: true)
  end

  describe 'GET api/nbp_currencies' do
    let(:request) { get '/api/nbp_currencies', params: { currency: 'USD', date: date, since: since } }

    context 'one day' do
      let(:date) { Date.yesterday.strftime('%Y-%m-%d') }
      let(:since) { nil }

      it 'returns currency for this day' do
        request
        expect(json).to eq([{ 'name' => 'USD', 'rate' => '1.5', 'day' => { 'date' => date } }])
      end
    end

    context 'range of days' do
      let(:date) { Date.yesterday.strftime('%Y-%m-%d') }
      let(:since) { (Date.yesterday - 5.days).strftime('%Y-%m-%d') }

      it 'returns currency for this day' do
        request
        expect(json.size).to eq(3)
      end
    end
  end
end
