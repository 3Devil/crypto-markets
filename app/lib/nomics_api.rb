# frozen_string_literal: true

require 'net/http'

# API handling for Nomics
class NomicsAPI
  class << self
    def list(ids, options = {})
      get 'currencies/ticker', ids: ids.join(','), **options
    end

    def filtered_list(ids, fields = [])
      list(ids).map { |item| item.select! { |k, v| fields.include?(k) } }
    end

    def list_with_currency(ids, currency)
      list(ids, convert: currency)
    end

    def get(endpoint, options = {})
      params = options.merge({ key: '26d17980c2ca716492bae0cf370dbd9cab0e9841' }).map { |k, v| "#{k}=#{v}" }.join('&')
      uri = URI("https://api.nomics.com/v1/#{endpoint}?#{params}")
      response = Net::HTTP.get_response(uri)

      case response
      when Net::HTTPSuccess
        JSON.parse(response.body)
      else
        { "error": 'Error while retrieving data' }
      end
    end
  end
end
