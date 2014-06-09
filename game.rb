#!/usr/bin/env ruby -w

require 'gosu'
require './lib/circle.rb'

# # # # # # # # # # # # #
# Web request notes 
# # # # # # # # # # # # #
# response = Net::HTTP.get_response("example.com","/?search=thing&format=json")
# puts response.body //this must show the JSON contents 
# # # # # # # # # # # # #
# require 'open-uri'
# content = open("http://your_url.com").read
# # # # # # # # # # # # #

class Window < Gosu::Window
  def initialize
    super 640, 480, false
    @img = Gosu::Image.new(self, Circle.new(200), false)
  end

	def draw 
		@img.draw 0, 0, 0
	end

	

  # def needs_cursor?
  #   true
  # end
end

window = Window.new
window.show