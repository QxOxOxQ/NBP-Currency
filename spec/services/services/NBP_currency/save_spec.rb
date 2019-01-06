# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::NBP_currency::Save, type: :service do
  describe '.call' do
    subject { described_class.call(currency: currency, since: since, date: date) }

    let(:currency) { 'USD' }

    let(:service) { double(Services::NBP_currency::Fetch) }

    context 'when service to fatch returns errors ' do
      let(:since) { :since }
      let(:date) { :date }

      let(:responce) { { errors: { date: 'Some error' } } }

      before do
        allow(Services::NBP_currency::Fetch)
          .to receive(:new)
            .with(currency: currency,
                  since: since,
                  date: date) { service }
        allow(service).to receive(:call) { responce }
      end

      it 'returns errors' do
        expect(subject).to eq(responce)
      end
    end

    context 'with correct attr and let date and since' do
      let(:since) { '2017-12-30' }
      let(:date) { '2018-01-09' }
      let(:response) do
        { 'table' => 'A',
          'currency' => 'dolar amerykański',
          'code' => 'USD',
          'rates' =>
             [{ 'no' => '001/A/NBP/2018', 'effectiveDate' => '2018-01-02', 'mid' => 3.4546 },
              { 'no' => '002/A/NBP/2018', 'effectiveDate' => '2018-01-03', 'mid' => 3.4616 },
              { 'no' => '003/A/NBP/2018', 'effectiveDate' => '2018-01-04', 'mid' => 3.4472 },
              { 'no' => '004/A/NBP/2018', 'effectiveDate' => '2018-01-05', 'mid' => 3.4488 },
              { 'no' => '005/A/NBP/2018', 'effectiveDate' => '2018-01-08', 'mid' => 3.4735 },
              { 'no' => '006/A/NBP/2018', 'effectiveDate' => '2018-01-09', 'mid' => 3.4992 }] }
      end
      let!(:count_of_days) { Day.count }
      let!(:count_of_currencies) { Currency.count }

      before do
        allow(Services::NBP_currency::Fetch)
          .to receive(:new)
            .with(currency: currency,
                  since: since,
                  date: date) { service }
        allow(service).to receive(:call) { response }

        subject
      end

      it 'saves currencies' do
        aggregate_failures do
          expect(Currency.count).to eq(count_of_currencies + response['rates'].size)

          Currency.order(:id).last(7).pluck(:rate).each_with_index do |rate, index|
            expect(rate).to eq(response['rates'][index]['mid'])
          end
        end
      end

      it 'saves days with currencies' do
        aggregate_failures do
          expect(Day.where(lack_of_currency: false).count).to eq(count_of_days + response['rates'].size)

          response['rates'].each do |currency|
            day = Day.find_by(date: currency['effectiveDate'])
            expect(day).to be_present
            expect(day.lack_of_currency).to eq false
          end
        end
      end

      it 'saves empty days' do
        expect(Day.where(date: ['2017-12-31', '2018-01-01', '2018-01-06', '2018-01-07'],
                         lack_of_currency: true)
                   .count).to eq(count_of_days + 4)
      end
    end
  end
end
