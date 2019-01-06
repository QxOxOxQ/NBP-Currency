# frozen_string_literal: true

FactoryBot.define do
  factory :day do
    sequence(:date) { |n| Date.today - n.days }
    lack_of_currency { false }
  end
end
