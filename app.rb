require 'sinatra'
require 'sinatra/json'

get '/example.json' do
	json data: [2,3,4,5,6,7,8,9,10]
end