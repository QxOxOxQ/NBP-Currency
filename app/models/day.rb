# frozen_string_literal: true

class Day < ApplicationRecord
  validates :date, presence: true
  has_many :currencies
end
