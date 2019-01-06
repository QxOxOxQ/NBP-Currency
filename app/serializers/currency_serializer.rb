# frozen_string_literal: true

class CurrencySerializer < ApplicationSerializer
  attributes :name, :rate
  belongs_to :day
end
