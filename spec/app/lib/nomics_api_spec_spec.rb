# frozen_string_literal: true

require 'rspec'

RSpec.describe NomicsAPI do
  context 'when requesting list of markets' do
    let(:markets) { %w[BTC ETH] }
    it 'returns the requested markets' do
      VCR.use_cassette('nomics_list') do
        expect(NomicsAPI.list(markets).collect { |item| item['id'] }).to match_array(markets)
      end
    end
  end

  context 'when requesting specific fields' do
    let(:markets) { %w[BTC] }
    let(:fields) { %w[name symbol price circulating_supply max_supply] }
    it 'returns only the requested fields' do
      VCR.use_cassette('nomics_filtered_list') do
        expect(NomicsAPI.filtered_list(markets, fields).first.keys).to match_array(fields)
      end
    end
  end

  context 'when requesting market in specific currency' do
    let(:markets) { %w[BTC] }
    let(:currency) { 'EUR' }
    it 'returns market value converted in requested currency' do
      VCR.use_cassette('nomics_custom_currency') do
        expect(NomicsAPI.list_with_currency(markets, currency).first['price']).to eq('54791.65422911')
      end
    end
  end

  context 'when requesting market in another market' do
    let(:markets) { %w[BTC] }
    let(:currency) { 'ETH' }
    it 'returns market value converted in requested market value' do
      VCR.use_cassette('nomics_custom_market') do
        expect(NomicsAPI.list_with_currency(markets, currency).first['price']).to eq('14.27178751')
      end
    end
  end
end
