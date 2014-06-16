#!/usr/bin/env ruby -w

#Gems
require 'gosu'
require 'json'
require 'httparty'

#Classes
require './lib/circle.rb'
require './lib/circle_image.rb'

#Modules
require './lib/timekeeper'
require './lib/iconlegend'
require './lib/colormap'

class Window < Gosu::Window

include TimeKeeper
include IconLegend
include ColorMap

  attr_accessor :x, :y


  HEIGHT = 900
  WIDTH = 1600

  def initialize
    super WIDTH, HEIGHT, false
    generate_tasks
    @count = 1
    @font = Gosu::Font.new(self, "assets/victor-pixel.ttf", 40)
    @symbol = {}
    @symbol[:sm] = {font: Gosu::Font.new(self, "assets/fontawesome-webfont.ttf", 18), offset_y: 10, offset_x: 7.5}
    @symbol[:md] = {font: Gosu::Font.new(self, "assets/fontawesome-webfont.ttf", 30), offset_y: 18, offset_x: 11}
    @symbol[:lg] = {font: Gosu::Font.new(self, "assets/fontawesome-webfont.ttf", 42), offset_y: 22, offset_x: 14}
  end

  def generate_tasks
    response = HTTParty.get('http://datasymbiote.herokuapp.com/api/tasks').body
    tasks = JSON.parse(response)

    @tasks = []

    tasks.each_with_index do |task, index|
      importance = task["importance"]
      category = task["category"]
      id = task["id"]
      urgency = (timeUsedPercentage(jsonToRubyDate(task["deadline"]), jsonToRubyDate(task["created_at"]))).round(0) / 10
      # urgency = [urgency, 11].min
      puts importance
      puts category
      puts urgency
      puts jsonToRubyDate(task["deadline"])
      puts jsonToRubyDate(task["created_at"])
      puts DateTime.now

      @tasks << CircleImage.new(self, Circle.new(importance * 7 + 5), false, index * 125, index * 80, urgency, importance, category, id)
    end
  end

  def draw
    # background color #
    color = Gosu::Color::BLACK
    draw_quad 0, 0, color, WIDTH, 0, color, WIDTH, HEIGHT, color, 0, HEIGHT, color
    # tasks #
    @tasks.each { |task|
      task.draw_rot task.x, task.y, 50, 90, 0.5, 0.5, 1, 1, task.color
      size = case (task.radius / 8)
      when 1..3 then :sm
      when 4..6 then :md
      when 7..10 then :lg
      end

      @symbol[size][:font].draw("#{ICONMAP[task.category]}", task.x - @symbol[size][:offset_x], task.y - @symbol[size][:offset_y], 50, 1, 1, Gosu::Color::WHITE)
    }
    @font.draw("#{Time.now.strftime "%H:%M:%S"}", 50, 820, 100, 1, 1, Gosu::Color::WHITE)
  end

  def update
    @count += 1
    detect_collisions
    @tasks.each do|task|
      refresh_data if @count % 600 == 0
      task.move!
    end
  end

  def detect_collisions
    @tasks.combination(2).each do |firstBall, secondBall|
      puts firstBall.x
      puts firstBall.radius
      puts secondBall.radius
      puts secondBall.x

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

  def async(arg, callback)
    Thread.new {
      resp = HTTParty.get(arg)
      callback.call(resp) 
    }
  end

  def refresh_data
    async 'http://datasymbiote.herokuapp.com/api/tasks', lambda { |response|
      task_json = JSON.parse(response.body)

      @tasks.each do |circle|
        task = task_json.find { |t| t['id'] == task.id }
        circle.update(task)
      end
    }
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
