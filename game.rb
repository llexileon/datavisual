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
require './lib/audioengine'
require './lib/timekeeper'
require './lib/iconlegend'
require './lib/colormap'

class Window < Gosu::Window

include AudioEngine
include TimeKeeper
include IconLegend
include ColorMap

  attr_accessor :x, :y, :mute

  HEIGHT = 900
  WIDTH = 1600

  def initialize
    super WIDTH, HEIGHT, false
    audio_engine
    # generate_tasks
    self.caption = "DataBounce"
    @mute == false
    @game_in_progress = false
    @mouse_location = [mouse_x, mouse_y]
    @count = 1
    @font = Gosu::Font.new(self, "assets/victor-pixel.ttf", 40)
    @text_fields = Array.new(1) { |index| TextField.new(self, @font, 460, 425) }
    @symbol = {}
    @symbol[:sm] = {font: Gosu::Font.new(self, "assets/fontawesome-webfont.ttf", 24), offset_y: 12, offset_x: 9}
    @symbol[:md] = {font: Gosu::Font.new(self, "assets/fontawesome-webfont.ttf", 32), offset_y: 18, offset_x: 11}
    @symbol[:lg] = {font: Gosu::Font.new(self, "assets/fontawesome-webfont.ttf", 42), offset_y: 22, offset_x: 14}
    @audio_icon = Gosu::Image.new(self, "assets/audioicon.png", false)
  end

  def login_screen
      @game_in_progress = false
      @text_fields[0].text
  end

  def setup_game
      puts @text_fields[0].text
      generate_tasks
      @game_in_progress = true
  end

  def generate_tasks
    response = HTTParty.get("http://datasymbiote.herokuapp.com/api/tasks?token=secret&email=#{@text_fields[0].text}").body
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
      done = task["done"]
      @tasks << CircleImage.new(self, Circle.new(((urgency * 3) + (importance * 3)) + 25), false, index * 125, index * 80, urgency, importance, category, id, title, description, deadline, done)
      @tasks.reject!(&:done)
      end
  end


  def draw
    # background color #
    color = Gosu::Color::BLACK
    draw_quad 0, 0, color, WIDTH, 0, color, WIDTH, HEIGHT, color, 0, HEIGHT, color
    unless @game_in_progress
    @font.draw("DataBounce", 450, 270, 50, 3.0, 3.0, Gosu::Color::WHITE)
    @font.draw("Login below, press enter to confirm", 450, 370, 50, 1, 1, Gosu::Color::rgb(38, 128, 203))
    @font.draw("Then press 'b' to Bounce", 450, 470, 50, 1, 1, Gosu::Color::rgb(38, 128, 203))
    @font.draw("or press 'q' to Quit", 450, 495, 50, 1, 1, Gosu::Color::rgb(38, 128, 203))  
    # text input #
    @text_fields.each { |tf| tf.draw }
    end
    return unless @game_in_progress

    # tasks #
    @tasks.reject(&:done).each { |task|
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
    if !@mute
      @audio_icon.draw(1510, 824, 100, 0.2, 0.2)
    end
  end

  def update
    if button_down? Gosu::KbQ
      close
    end
    if button_down? Gosu::KbB
      setup_game unless @game_in_progress
    end
    if button_down? Gosu::KbL
      login_screen unless @game_in_progress == false
      # @game_in_progress = false
    end
    @count += 1
    return unless @game_in_progress
    detect_collisions
    @tasks.each do|task|
      if @count > 600
        refresh_data 
        @count = 0
      end
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
          @bounce_sample.play(0.4) unless @mute == true
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
    elsif id == Gosu::KbReturn
      if self.text_input then
        self.text_input = nil
      end
    elsif id == Gosu::KbEscape then
      if self.text_input then
        self.text_input = nil
      else
        close
      end
    elsif id == Gosu::MsLeft
      if @game_in_progress 
        detect_clicks
      else
      self.text_input = @text_fields.find { |tf| tf.under_point?(mouse_x, mouse_y) }
      self.text_input.move_caret(mouse_x) unless self.text_input.nil?
      end
    elsif id == Gosu::KbM
      toggle_mute!
    end
  end

  def detect_clicks
    @tasks.each do |task|
      if mouse_clicks?(task)
        task.toggle_freeze!
        @freeze_sample.play unless @mute == true
        @deleters << Deleter.new(self, task)
      end
    end

    @deleters.each do |deleter|
      @tasks.each do |task|
        if mouse_clicks?(deleter)
          @count = 0
          put_done(deleter.task)
          deleter.task.done = true
          @tasks.delete(deleter.task)
          @deleters.delete(deleter)
        end
      end
    end
  end


  def async_get(arg, callback)
    Thread.new {
      resp = HTTParty.get(arg)
      callback.call(resp)
    }
  end

    def async_put(arg, data)
    Thread.new {
      resp = HTTParty.put(arg, data)
    }
  end

  def put_done(task)
    async_put("http://datasymbiote.herokuapp.com/api/tasks/#{task.id}?token=secret&email=#{@text_fields[0].text}", body: { task: { done: true } })    
  end


  def refresh_data
    async_get "http://datasymbiote.herokuapp.com/api/tasks?token=secret&email=#{@text_fields[0].text}", lambda { |response|
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
