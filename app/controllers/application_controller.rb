# frozen_string_literal: true

# Main controller
class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    erb :index
  end

  # Task 1 - list full data for list of markets
  get '/list/:ids' do
    content_type :json
    NomicsAPI.list(clean_ids).to_json
  end

  # Task 2 - show specific fields for list of markets
  get '/filtered_list/:ids/:fields' do
    content_type :json
    NomicsAPI.filtered_list(clean_ids, clean_fields).to_json
  end

  # Task 3 - list full data for list of markets in specific currency
  get '/to_currency/:ids/:currency' do
    content_type :json
    NomicsAPI.list_with_currency(clean_ids, currency).to_json
  end

  helpers do
    def clean_ids
      params[:ids].split(',').map(&:strip).map(&:upcase)
    end

    def clean_fields
      params[:fields].split(',').map(&:strip).map(&:downcase)
    end

    def currency
      params[:currency].upcase
    end
  end
end
