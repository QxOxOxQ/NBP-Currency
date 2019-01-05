# frozen_string_literal: true

class Currency < ApplicationRecord
  belongs_to :day

  validates :name, :rate, presence: true
  validates :name, length: { is: 3 }
  validates :name, uniqueness: { scope: :day_id }
end
