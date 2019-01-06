# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SaveNBPCurrencyWorker, type: :job do
  describe '#perform later' do
    it 'enqueued job' do
      ActiveJob::Base.queue_adapter = :test
      expect do
        described_class.perform_later(authorable_class: nil,
                                      commentable_class: nil,
                                      commentable_id: nil)
      end.to have_enqueued_job
    end
  end

  describe '#perform now' do
    subject(:perform) do
      described_class.new.perform(since: since,
                                  date: date,
                                  currency: currency)
    end

    let(:since) { :since }
    let(:date) { :date }
    let(:currency) { :currency }

    before do
      service = double(Services::NBP_currency::Save)
      allow(Services::NBP_currency::Save)
        .to receive(:new)
          .with(currency: currency,
                since: since,
                date: date) { service }
      allow(service).to receive(:call).and_return(:ok)
    end

    it 'run service' do
      expect(perform).to eq :ok
    end

    it 'without currency raise error' do
      expect do
        described_class.new.perform(since: since,
                                    date: date)
      end .to raise_error(ArgumentError, /missing keyword: currency/)
    end
  end
end
