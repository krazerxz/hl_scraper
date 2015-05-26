require 'spec_helper'

xdescribe HL do
  describe '.new' do
    it 'should load the config' do
      expect(YAML).to receive(:load)
      HL.new
    end

    it 'should log in to hl' do
      expect(HL).to receive(:login)
      HL.new
    end
  end

  describe '.login' do
    it 'should log in to hl' do
    end
  end
end
