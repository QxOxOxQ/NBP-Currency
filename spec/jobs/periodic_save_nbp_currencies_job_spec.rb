# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PeriodicSaveNBPCurrenciesJob, type: :job do
  describe '#perform later' do
    it 'enqueued job' do
      ActiveJob::Base.queue_adapter = :test
      expect do
        described_class.perform_later
      end.to have_enqueued_job
    end
  end
end
