#!/usr/bin/env ruby -w

require 'gosu'

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
    super 320, 240, false
  end

  def needs_cursor?
    true
  end
end

window = Window.new
window.show