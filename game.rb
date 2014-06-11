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
    @font = Gosu::Font.new(self, "assets/victor-pixel.ttf", 35)
  end

  def generate_tasks
    @tasks = Array.new [
      @task1 = CircleImage.new(self, Circle.new, false,0),
      @task2 = CircleImage.new(self, Circle.new, false,100),
      @task3 = CircleImage.new(self, Circle.new, false,200),
      @task4 = CircleImage.new(self, Circle.new, false,300),
      @task5 = CircleImage.new(self, Circle.new, false,400),
      @task6 = CircleImage.new(self, Circle.new, false,500),
      @task7 = CircleImage.new(self, Circle.new, false,600),
      @task8 = CircleImage.new(self, Circle.new, false,700),
      @task9 = CircleImage.new(self, Circle.new, false,800),
      @task10 = CircleImage.new(self, Circle.new, false,900)
    ]
  end

  def draw
    # background color #
    color = Gosu::Color::BLACK
    draw_quad 0, 0, color, WIDTH, 0, color, WIDTH, HEIGHT, color, 0, HEIGHT, color
    # tasks #
    @tasks.each { |task|
      task.draw_rot task.x, task.y, 50, 90, 0.5, 0.5, 1, 1, task.color
      @font.draw("#{task.angle.round(2)}", task.x - 10, task.y - 24, 50, 1, 1, Gosu::Color::WHITE)
    }
  end

  def update
    detect_collisions
    @tasks.each { |task| task.move! }
  end

  def detect_collisions
    @tasks.combination(2).each do |firstBall, secondBall|
      a_hit = firstBall.x + firstBall.radius + secondBall.radius >= secondBall.x
      b_hit = firstBall.x <= secondBall.x + firstBall.radius + secondBall.radius
      c_hit = firstBall.y + firstBall.radius + secondBall.radius >= secondBall.y
      d_hit = firstBall.y <= secondBall.y + firstBall.radius + secondBall.radius
      
      if(a_hit && b_hit && c_hit && d_hit)
        distance = Math.sqrt(((firstBall.x - secondBall.x) * (firstBall.x - secondBall.x)) + ((firstBall.y - secondBall.y) * (firstBall.y - secondBall.y)))
        if (distance < firstBall.radius + secondBall.radius)
          # collision detected now what?
          collisionPointX = ((firstBall.x * secondBall.radius) + (secondBall.x * firstBall.radius)) / (firstBall.radius + secondBall.radius)
          collisionPointY = ((firstBall.y * secondBall.radius) + (secondBall.y * firstBall.radius)) / (firstBall.radius + secondBall.radius)
          puts "collision at #{collisionPointX},#{collisionPointY}"

          newVelX1 = (firstBall.speed_x * (firstBall.mass - secondBall.mass) + (2 * secondBall.mass * secondBall.speed_x)) / (firstBall.mass + secondBall.mass)
          newVelY1 = (firstBall.speed_y * (firstBall.mass - secondBall.mass) + (2 * secondBall.mass * secondBall.speed_y)) / (firstBall.mass + secondBall.mass)
          newVelX2 = (secondBall.speed_x * (secondBall.mass - firstBall.mass) + (2 * firstBall.mass * firstBall.speed_x)) / (firstBall.mass + secondBall.mass)
          newVelY2 = (secondBall.speed_y * (secondBall.mass - firstBall.mass) + (2 * firstBall.mass * firstBall.speed_y)) / (firstBall.mass + secondBall.mass)

          firstBall.speed_x = newVelX1
          firstBall.speed_y = newVelY1

          secondBall.speed_x = newVelX2
          secondBall.speed_y = newVelY2
        end
      end
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
