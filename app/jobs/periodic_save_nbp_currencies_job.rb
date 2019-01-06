# frozen_string_literal: true

class PeriodicSaveNBPCurrenciesJob < ApplicationJob
  queue_as :periodic_save_nbp_currency
  CURRENCIES = %w[USD EUR].freeze
  def perform
    since = if Day.find_by(date: Date.yesterday).present?
              nil
            else
              Date.yesterday.strftime('%Y-%m-%d')
            end

    CURRENCIES.each do |currency|
      SaveNBPCurrencyJob(currency: currency,
                         since: since,
                         date: Date.today)
    end
  end
end
