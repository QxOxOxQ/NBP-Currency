# frozen_string_literal: true

class SaveNBPCurrencyJob < ApplicationJob
  queue_as :save_nbp_currency

  def perform(currency:, since: nil, date:)
    Services::NBP_currency::Save.call(currency: currency,
                                      date: date,
                                      since: since)
  end
end
