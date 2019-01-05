# frozen_string_literal: true

module Services
  module NBP_currency
    class Fetch < Services::Application
      ALLOW_DAYS_BY_API = 93
      def initialize(currency:, date: Date.current, since: nil)
        @currency = currency
        @date = date
        @since = since.nil? ? date : since
        @errors = {}
      end

      def call
        return hash_errors unless valid?

        request
        return hash_errors if request == :error || !equal_response_with_request?

        response
      end

      private

      def hash_errors
        { errors: @errors }
      end

      def response
        @response ||= JSON.parse(request)
      end

      def request
        @request ||= RestClient.get url, params
      rescue RestClient::ExceptionWithResponse
        @errors[:response] = I18n.t('nbp.errors.response.lack_of_data')
        :error
      end

      def equal_response_with_request?
        @errors[:response] = I18n.t('nbp.errors.response.wrong_table') unless
            table.casecmp(response['table']).zero?
        @errors[:response] = I18n.t('nbp.errors.response.wrong_code') unless
            @currency.casecmp(response['code']).zero?
        @errors[:response].nil?
      end

      def url
        "http://api.nbp.pl/api/exchangerates/rates/#{table}/#{@currency}/#{@date}/"
      end

      def params
        { params: { format: 'json' } }
      end

      def table
        'a'
      end

      def converted_date
        @converted_date ||= Date.strptime(@date, '%Y-%m-%d')
      rescue ArgumentError
        :ArgumentError
      end

      def converted_since
        @converted_since ||= Date.strptime(@since, '%Y-%m-%d')
      rescue ArgumentError
        :ArgumentError
      end

      def valid?
        valid
        @errors.empty?
      end

      def valid
        unless valid_currency_format?
          @errors[:currency] = I18n.t('nbp.errors.currency.wrong_format')
          return
        end
        unless valid_date_format?
          @errors[:date] = I18n.t('nbp.errors.date.wrong_format')
          return
        end
        if range_between_dates_more_than_93_days?
          @errors[:date] = I18n.t('nbp.errors.date.range_between_dates_cannot_be_more_than_93_days')
          return
        end
        @errors[:date] = I18n.t('nbp.errors.date.since_cannot_be_after_date') if since_is_after_date?
        @errors[:date] = I18n.t('nbp.errors.date.cannot_be_in_future') if date_is_in_future?
      end

      def valid_currency_format?
        @currency.is_a?(String) && @currency.size == 3
      end

      def valid_date_format?
        converted_date != :ArgumentError && converted_since != :ArgumentError
      end

      def range_between_dates_more_than_93_days?
        (converted_date - converted_since).to_i > ALLOW_DAYS_BY_API
      end

      def since_is_after_date?
        (converted_date - converted_since).to_i < 0
      end

      def date_is_in_future?
        Date.tomorrow <= converted_date
      end
    end
  end
end
