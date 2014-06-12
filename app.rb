require 'sinatra'
require 'sinatra/json'

get '/example.json' do
	json data: [4,3,3,4,5,7,7,9,9,10]
end