# frozen_string_literal: true

FactoryBot.define do
  factory :currency do
    name { 'EUR' }
    rate { 1.5 }
    day
  end
end
