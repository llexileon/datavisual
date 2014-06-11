require 'sinatra'
require 'sinatra/json'

get '/example.json' do
	json data: [7,6,5,4,3,2]
end