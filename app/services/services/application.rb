# frozen_string_literal: true

module Services
  class Application
    def self.call(*args)
      new(*args).call
    end

    def valid?
      @error.present?
    end
  end
 end
