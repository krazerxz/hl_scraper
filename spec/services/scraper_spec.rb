require 'spec_helper'

describe Scraper do
  describe '.run' do
    it 'logs in to hl' do
      expect(HL).to receive(:new)
      subject.run
    end
  end
end
