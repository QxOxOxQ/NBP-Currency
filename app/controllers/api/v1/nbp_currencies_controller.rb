# frozen_string_literal: true

module Api
  module V1
    class NbpCurrenciesController < ApplicationController
      def index
        range = convert_date(attributes[:since])..convert_date(attributes[:date])
        currencies = Currency.includes(:day)
                             .where(days: { date: range })
                             .where(name: attributes[:currency]).order('days.date asc')
        fetch_lack_of_records(range, currencies)

        render json: currencies, status: :ok
      end

      private

      def fetch_lack_of_records(range, currencies)
        date_to_fetch = range.to_a - currencies.map { |currency| currency.day.date }

        (date_to_fetch -= Day.where(date: date_to_fetch, lack_of_currency: true)) if date_to_fetch.present?
        if date_to_fetch.present?
          date_to_fetch.each do |date|
            SaveNBPCurrencyJob.perform_later(currency: attributes[:currency], date: date.strftime('%Y-%m-%d'))
          end
        end
      end

      def attributes
        @attributes ||=
          {
            date: params[:date],
            since: (params[:since].nil? ? params[:date] : params[:since]),
            currency: params[:currency].upcase
          }
      end

      def convert_date(date)
        Date.strptime(date, '%Y-%m-%d')
      end
    end
  end
end
