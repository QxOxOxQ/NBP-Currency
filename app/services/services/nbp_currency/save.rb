# frozen_string_literal: true

module Services
  module NBPCurrency
    class Save < Services::Application
      def initialize(currency:, date: Date.current, since: nil)
        @currency = currency
        @date = date
        @since = since || date
        @saved_date = []
      end

      def call
        return currencies if currencies[:errors].present?

        save_currencies
        save_empty_days
      end

      private

      def currencies
        @currencies ||= Services::NBPCurrency::Fetch.call(currency: @currency,
                                                          date: @date,
                                                          since: @since)
      end

      def save_currencies
        currencies['rates'].map do |currency|
          day = Day.find_or_create_by(date: convert_date(currency['effectiveDate']))

          currency = Currency.new(name: @currency.upcase,
                                  day: day,
                                  rate: currency['mid'])

          @saved_date << day.date if currency.save
        end
      end

      def save_empty_days
        empty_date = (convert_date(@since)..convert_date(@date)).to_a - (@saved_date << Date.today)
        empty_date.each do |date|
          Day.create(date: date, lack_of_currency: true)
        end
      end

      def convert_date(date)
        Date.strptime(date, '%Y-%m-%d')
      end
    end
  end
end
