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
    @circles = Array.new [
    @task1 = Gosu::Image.new(self, Circle.new(rand(20..80)), false),
    @task2 = Gosu::Image.new(self, Circle.new(rand(20..80)), false),
    @task3 = Gosu::Image.new(self, Circle.new(rand(20..80)), false),
    @task4 = Gosu::Image.new(self, Circle.new(rand(20..80)), false)
    ]
  end

	def draw 
    # background color #
    color = Gosu::Color::WHITE
    draw_quad 0, 0, color, WIDTH, 0, color, WIDTH, HEIGHT, color, 0, HEIGHT, color

    # @circles.each { |q| q.draw_rot @circle_x, @circle_y, 70, 90, 0.5, 0.5, 1, 1, Gosu::Color::BLUE }

    # tasks #
    @task1.draw_rot WIDTH/2, HEIGHT/3, 70, 90, 0.5, 0.5, 1, 1, Gosu::Color::BLUE
    @task2.draw_rot WIDTH/4, HEIGHT/3, 60, 90, 0.5, 0.5, 1, 1, Gosu::Color::FUCHSIA
    @task3.draw_rot WIDTH/2, HEIGHT/6, 50, 90, 0.5, 0.5, 1, 1, Gosu::Color::YELLOW
    @task4.draw_rot WIDTH/6, HEIGHT/5, 40, 90, 0.5, 0.5, 1, 1, Gosu::Color::GREEN
	end


  def needs_cursor?
    true
  end

  def button_down(id)
    close if id == Gosu::KbQ
  end  
end

window = Window.new
window.show