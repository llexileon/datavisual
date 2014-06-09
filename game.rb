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
  
  HEIGHT = 640
  WIDTH = 480

  def initialize
    super WIDTH, HEIGHT, false
    @img = Gosu::Image.new(self, Circle.new(50), false)
  end  

	def draw 
		@img.draw_rot WIDTH/2, HEIGHT/2, 1, 90, 0.5, 0.5, 1, 1, Gosu::Color::BLUE
	end

  def needs_cursor?
    true
  end
end

window = Window.new
window.show