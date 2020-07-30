require 'sinatra'
require './lib/coordinators/validate_coordinator'

get '/validate' do
  ValidateCoordinator.new(card_number: params['card_number']).call.to_json
rescue
  status 400
end