# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::NBP_currency::Fetch, type: :service do
  describe '.call' do
    subject { described_class.call(currency: currency, since: since, date: date) }

    let(:since) { nil }
    let(:response) do
      { status: 200,
        body: "{\"table\":\"A\",
              \"currency\":\"euro\",
              \"code\":\"EUR\",
              \"rates\":[{\"no\":\"002/A/NBP/2018\",\"effectiveDate\":\"#{date}\",\"mid\":4.1673}]}" }
    end
    before do
      stub_request(:get,
                   "http://api.nbp.pl/api/exchangerates/rates/a/#{currency}/#{date}/#{date}/?format=json")
        .to_return(response)
    end

    let(:currency) { 'EUR' }

    context 'when request date is valid' do
      let(:date) { (Date.current - 3.days).strftime('%Y-%m-%d') }

      context 'when currency is valid' do
        it 'returns currency' do
          expect(subject).to eq(JSON.parse(response[:body]))
        end
      end

      context 'when since is presence' do
        let(:since) { (Date.current - 13.days).strftime('%Y-%m-%d') }
        let(:response) do
          { status: 200,
            body: "{\"table\":\"A\",
              \"currency\":\"euro\",
              \"code\":\"EUR\",
              \"rates\":[{\"no\":\"002/A/NBP/2018\",\"effectiveDate\":\"#{date}\",\"mid\":4.1673},
                         {\"no\":\"003/A/NBP/2018\",\"effectiveDate\":\"#{date}\",\"mid\":4.44}]}" }
        end

        before do
          stub_request(:get,
                       "http://api.nbp.pl/api/exchangerates/rates/a/#{currency}/#{since}/#{date}/?format=json")
            .to_return(response)
        end

        it 'response currency' do
          expect(subject).to eq(JSON.parse(response[:body]))
        end
      end

      context 'when currency is invalid' do
        let(:currency) { '0123' }

        it 'returns error' do
          expect(subject).to eq(errors: { currency: I18n.t('nbp.errors.currency.wrong_format') })
        end
      end

      context 'when currency is invalid' do
        let(:currency) { '0123' }

        it 'returns error' do
          expect(subject).to eq(errors: { currency: I18n.t('nbp.errors.currency.wrong_format') })
        end
      end
    end

    context 'when request date is invalid' do
      let(:date) { (Date.current - 5.days).strftime('%m-%Y-%d') }

      it 'returns error' do
        expect(subject).to eq(errors: { date: I18n.t('nbp.errors.date.wrong_format') })
      end
    end

    context 'when request since is invalid' do
      let(:date) { Date.current.strftime('%Y-%m-%d') }
      let(:since) { (Date.current - 5.days).strftime('%m-%Y-%d') }

      it 'returns error' do
        expect(subject).to eq(errors: { date: I18n.t('nbp.errors.date.wrong_format') })
      end
    end

    context 'when range of dates is 93 days' do
      let(:date) { Date.current.strftime('%Y-%m-%d') }
      let(:since) { (Date.current - 93.days).strftime('%Y-%m-%d') }

      let(:response) do
        { status: 200,
          body: "{\"table\":\"A\",
              \"currency\":\"euro\",
              \"code\":\"EUR\",
              \"rates\":[{\"no\":\"002/A/NBP/2018\",\"effectiveDate\":\"#{date}\",\"mid\":4.1673},
                         {\"no\":\"003/A/NBP/2018\",\"effectiveDate\":\"#{date}\",\"mid\":4.44}]}" }
      end

      before do
        stub_request(:get,
                     "http://api.nbp.pl/api/exchangerates/rates/a/#{currency}/#{since}/#{date}/?format=json")
          .to_return(response)
      end

      it 'returns response' do
        expect(subject).to eq(JSON.parse(response[:body]))
      end
    end

    context 'when range of dates is 94 days' do
      let(:date) { Date.current.strftime('%Y-%m-%d') }
      let(:since) { (Date.current - 94.days).strftime('%Y-%m-%d') }

      it 'returns error' do
        expect(subject).to eq(errors: { date: I18n.t('nbp.errors.date.range_between_dates_cannot_be_more_than_93_days') })
      end
    end

    context 'when request date is tomorrow' do
      let(:date) { Date.tomorrow.strftime('%Y-%m-%d') }

      it 'returns error' do
        expect(subject).to eq(errors: { date: I18n.t('nbp.errors.date.cannot_be_in_future') })
      end
    end

    context 'when request since is after date' do
      let(:date) { Date.yesterday.strftime('%Y-%m-%d') }
      let(:since) { Date.tomorrow.strftime('%Y-%m-%d') }

      it 'returns error' do
        expect(subject).to eq(errors: { date: I18n.t('nbp.errors.date.since_cannot_be_after_date') })
      end
    end
  end
end
