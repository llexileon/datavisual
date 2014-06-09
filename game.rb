#!/usr/bin/env ruby -w

require 'gosu'
require './lib/circle.rb'
require './lib/circle_image.rb'

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

  attr_accessor :x, :y

  
  HEIGHT = 640
  WIDTH = 480

  def initialize
    super WIDTH, HEIGHT, false
    generate_tasks
    # @circles = Array.new [
    # @task1 = Gosu::Image.new(self, Circle.new(rand(20..80)), false),
    # @task2 = Gosu::Image.new(self, Circle.new(rand(20..80)), false),
    # @task3 = Gosu::Image.new(self, Circle.new(rand(20..80)), false),
    # @task4 = Gosu::Image.new(self, Circle.new(rand(20..80)), false)
    # ]
  end

  def generate_tasks
        @tasks = Array.new [
    @task1 = CircleImage.new(self, Circle.new(@radius), false),
    @task2 = CircleImage.new(self, Circle.new(@radius), false),
    @task3 = CircleImage.new(self, Circle.new(@radius), false),
    @task4 = CircleImage.new(self, Circle.new(@radius), false)
    ]
  end

	def draw 
    # background color #
    color = Gosu::Color::WHITE
    draw_quad 0, 0, color, WIDTH, 0, color, WIDTH, HEIGHT, color, 0, HEIGHT, color

    @tasks.each { |task| task.draw_rot task.x, task.y, 70, 90, 0.5, 0.5, 1, 1, task.color }

    # # tasks #
    # @task1.draw_rot @task1.x, @task1.y, 70, 90, 0.5, 0.5, 1, 1, Gosu::Color::BLUE
    # @task2.draw_rot @task2.x, @task2.y, 60, 90, 0.5, 0.5, 1, 1, Gosu::Color::FUCHSIA
    # @task3.draw_rot @task3.x, @task3.y, 50, 90, 0.5, 0.5, 1, 1, Gosu::Color::YELLOW
    # @task4.draw_rot @task4.x, @task4.y, 40, 90, 0.5, 0.5, 1, 1, Gosu::Color::GREEN
	end

  def update
    @tasks.each { |task| task.move! }
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