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

  
  HEIGHT = 900
  WIDTH = 900

  def initialize
    super WIDTH, HEIGHT, false
    generate_tasks
  end

  def generate_tasks
        @tasks = Array.new [
    @task1 = CircleImage.new(self, Circle.new(@radius), false),
    @task2 = CircleImage.new(self, Circle.new(@radius), false),
    @task3 = CircleImage.new(self, Circle.new(@radius), false),
    @task4 = CircleImage.new(self, Circle.new(@radius), false),
    @task5 = CircleImage.new(self, Circle.new(@radius), false)
    ]
  end

	def draw 
    # background color #
    color = Gosu::Color::BLACK
    draw_quad 0, 0, color, WIDTH, 0, color, WIDTH, HEIGHT, color, 0, HEIGHT, color
    # tasks #
    @tasks.each { |task| task.draw_rot task.x, task.y, 70, 90, 0.5, 0.5, 1, 1, task.color }
	end

  def update
    # detect_collisions
    @tasks.each { |task| task.move! }
  end

  def collision?(object_1, object_2)
      hitbox_1, hitbox_2 = object_1.hitbox, object_2.hitbox
      common_x = hitbox_1[:x] & hitbox_2[:x]
      common_y = hitbox_1[:y] & hitbox_2[:y]
      common_x.size > 0 && common_y.size > 0 
  end

  def detect_collisions
      if collision?(@task1, @task2)
          @counter = 1
          puts "bump #{@counter += 1}"
      end
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