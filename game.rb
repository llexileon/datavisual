#!/usr/bin/env ruby -w

#Gems
require 'gosu'
require 'json'
require 'httparty'

#Classes
require './lib/circle.rb'
require './lib/circle_image.rb'
require './lib/deleter.rb'
require './lib/textfield.rb'

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
    self.caption = "DataBounce"
    @mouse_location = [mouse_x, mouse_y]
    @count = 1
    @font = Gosu::Font.new(self, "assets/victor-pixel.ttf", 40)
    @text_fields = Array.new(1) { |index| TextField.new(self, @font, 50, (30 + index * 50)) }
    @symbol = {}
    @symbol[:sm] = {font: Gosu::Font.new(self, "assets/fontawesome-webfont.ttf", 24), offset_y: 12, offset_x: 9}
    @symbol[:md] = {font: Gosu::Font.new(self, "assets/fontawesome-webfont.ttf", 32), offset_y: 18, offset_x: 11}
    @symbol[:lg] = {font: Gosu::Font.new(self, "assets/fontawesome-webfont.ttf", 42), offset_y: 22, offset_x: 14}
  end

  def generate_tasks
    response = HTTParty.get('http://datasymbiote.herokuapp.com/api/tasks?token=secret&email=joey@wolf.com').body
    tasks = JSON.parse(response)

    @tasks = []
    @deleters = []

    task_maker(tasks)
  end

  def task_maker(tasks)
      tasks.each_with_index do |task, index|
      importance = task["importance"]
      category = task["category"]
      id = task["id"]
      urgency = (timeUsedPercentage(jsonToRubyDate(task["deadline"]), jsonToRubyDate(task["created_at"]))).round(0) / 10
      title = task["title"]
      description = task["description"]
      deadline = jsonToRubyDate(task["deadline"])
      @tasks << CircleImage.new(self, Circle.new(((urgency * 3) + (importance * 3)) + 25), false, index * 125, index * 80, urgency, importance, category, id, title, description, deadline)
    end
  end


  def draw
    # background color #
    color = Gosu::Color::BLACK
    draw_quad 0, 0, color, WIDTH, 0, color, WIDTH, HEIGHT, color, 0, HEIGHT, color
    # text input #
    @text_fields.each { |tf| tf.draw }
    # tasks #
    @tasks.each { |task|
      task.draw_rot task.x, task.y, 50, 90, 0.5, 0.5, 1, 1, task.color
      size = case (task.radius / 8)
      when 1..3 then :sm
      when 4..6 then :md
      when 7..10 then :lg
      end

      @symbol[size][:font].draw("#{ICONMAP[task.category]}", task.x - @symbol[size][:offset_x], task.y - @symbol[size][:offset_y], 50, 1, 1, task.pastdue?)
      if task.frozen == true
        @font.draw("#{task.title}", task.x + 45, task.y, 100, 1, 1, Gosu::Color::WHITE)
        @font.draw("#{task.description}", task.x + 45, task.y + 25, 100, 1, 1, task.color)
        @font.draw("#{due_in(task.deadline)}", task.x + 45, task.y + 50, 100, 1, 1, task.overdue?)
        @deleters.each(&:draw)
      end
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

    if @new_tasks
      task_maker(@new_tasks)
      @new_tasks = nil
    end
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
          # puts "collision at #{collisionPointX},#{collisionPointY}"

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

  def mouse_clicks?(task)
      hitbox_1, = task.hitbox
      hitbox_1[:x].cover?(mouse_x) && hitbox_1[:y].cover?(mouse_y)
  end

  def button_down(id)
    if id == Gosu::KbTab then
      index = @text_fields.index(self.text_input) || -1
      self.text_input = @text_fields[(index + 1) % @text_fields.size]
    elsif id == Gosu::KbEscape then
      if self.text_input then
        self.text_input = nil
      else
        close
      end
    elsif id == Gosu::MsLeft
      detect_clicks
      self.text_input = @text_fields.find { |tf| tf.under_point?(mouse_x, mouse_y) }
      self.text_input.move_caret(mouse_x) unless self.text_input.nil?
    end
  end

  def detect_clicks
    @tasks.each do |task|
      if mouse_clicks?(task)
        task.toggle_freeze!
        @deleters << Deleter.new(self, task)
      end
    end

    @deleters.each do |deleter|
      if mouse_clicks?(deleter)
        @tasks.delete(deleter.task)
        @deleters.delete(deleter)
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
    async 'http://datasymbiote.herokuapp.com/api/tasks?token=secret&email=joey@wolf.com', lambda { |response|
      task_json = JSON.parse(response.body)

      @tasks.each do |circle|
        task = task_json.find { |t| t['id'] == circle.id }
        circle.update(task)
      end
      
      @new_tasks = task_json.reject do |json|
        @tasks.any? { |t| t.id == json['id'] }
      end
    }
    
  end

  def needs_cursor?
    true
  end

end

window = Window.new
window.show
