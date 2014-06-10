class CircleImage < Gosu::Image

	attr_accessor :x, :y, :color, :angle, :speed

	def initialize(window, source, tileable)
		super
		@color = color_picker
		@x = rand(100..500)
		@y = rand(100..600)
		@speed = rand(1..5)
		@angle = rand(50..150)
	end

	def hitbox
		hitbox_x = ((@x - self.width/2).to_i..(@x + self.width/2.to_i)).to_a
		hitbox_y = ((@y - self.width/2).to_i..(@y + self.width/2).to_i).to_a
		{:x => hitbox_x, :y => hitbox_y}
	end	

	def speed_x	
		Gosu.offset_x(angle, speed) 
	end

	def speed_y 
		Gosu.offset_y(angle, speed) 
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

		if @x > 900
			@x = 900
			x_bounce!
		end		
	end

	def y_bounce!
		@angle = Gosu.angle(0, 0, speed_x, -speed_y)	
	end

    def x_bounce!
		@angle = Gosu.angle(0, 0, -speed_x, speed_y)	
	end


	def color_picker
		@color = [  Gosu::Color::GRAY,
			Gosu::Color::AQUA, Gosu::Color::RED,
			Gosu::Color::GREEN, Gosu::Color::BLUE,
			Gosu::Color::YELLOW, Gosu::Color::FUCHSIA,
			Gosu::Color::CYAN ].sample
	end
end