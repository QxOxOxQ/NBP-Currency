# frozen_string_literal: true

class SaveNBPCurrencyJob < ApplicationJob
  queue_as :save_NBPCurrency

  def perform(currency:, since: nil, date:)
    Services::NBPCurrency::Save.call(currency: currency,
                                     date: date.is_a?(Date) ? date.strftime('%Y-%m-%d') : date,
                                     since: since)
  end
end
