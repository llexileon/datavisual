
require './lib/colormap.rb'

class CircleImage < Gosu::Image

	attr_accessor :x, :y, :color, :speed, :mass, :title, :category, :description
	attr_reader :radius, :importance, :id, :frozen
	attr_writer :speed_x, :speed_y

	include ColorMap

	def initialize(window, source, tileable, start_x, start_y, urgency, importance, category, id, title, description)
		super(window,source,tileable)
		@color = COLORMAP[urgency] 
		@description = description
		@id = id
		@frozen = false
		@title = title
		@category = category 
		@x = start_x  
		@y = start_y
		@urgency = urgency
		speed = importance/1.7
		angle = rand(50..150)
		@radius = self.width/2
	    @mass = 10
		@speed_x = Gosu.offset_x(angle, speed) 
		@speed_y = Gosu.offset_y(angle, speed) 
	end

	# def scale
	# 	@radius = importance
	# end

	def angle 
		Gosu.angle(0, 0, speed_x, -speed_y)	
	end
	
	def toggle_freeze!
		@frozen = !@frozen
	end

	def speed_x
		return -@speed_x if @frozen
		@speed_x
	end

	def speed_y 
		return -@speed_y if @frozen
		@speed_y
	end

	def move!
		return if @frozen
		@x += speed_x
		@y += speed_y 

		if @y < 0
			@y = 0
			y_bounce!
		end

		if @y > 900
			@y = 900
			y_bounce!
		end

		if @x < 0
			@x = 0
			x_bounce!
		end

		if @x > 1600
			@x = 1600
			x_bounce!
		end		
	end

	def y_bounce!
		@speed_y = -@speed_y 
	end

    def x_bounce!
		@speed_x = -@speed_x 
	end

	def update(data)
		@category = data["category"]
		@color = COLORMAP[@urgency]
		@title = data["title"]
	end

	def hitbox
  		hitbox_x = ((@x - self.width/2).to_i..(@x + self.width/2.to_i))
  		hitbox_y = ((@y - self.width/2).to_i..(@y + self.width/2).to_i)
  		{:x => hitbox_x, :y => hitbox_y}
  	end

end