
require './lib/colormap.rb'

class CircleImage < Gosu::Image

	attr_accessor :x, :y, :color, :speed, :mass, :speed_x, :speed_y
	attr_reader :radius, :category, :importance, :id

	include ColorMap

	def initialize(window, source, tileable, start_x, start_y, urgency, importance, category, id)
		super(window,source,tileable)
		@color = COLORMAP[urgency] 
		@id = id
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
	
	def move!
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
	end

end