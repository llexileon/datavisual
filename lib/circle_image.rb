class CircleImage < Gosu::Image

	attr_accessor :x, :y, :color

	def initialize(window, source, tileable)
		@color = color_picker
		@x = rand(1..500)
		@y = rand(1..600)
		@speed_x = rand(0..1)
		@speed_y = rand(1..4)
		super
	end

	def hitbox
		hitbox_x = ((@x - self.width/2).to_i..(@x + self.width/2.to_i)).to_a
		hitbox_y = ((@y - self.width/2).to_i..(@y + self.width/2).to_i).to_a
		{:x => hitbox_x, :y => hitbox_y}
	end	

	def move!
		@x += @speed_x
		@y += @speed_y 

		@x %= 900
        @y %= 900
	end

	def color_picker
		@color = [  Gosu::Color::GRAY, Gosu::Color::WHITE,
			Gosu::Color::AQUA, Gosu::Color::RED,
			Gosu::Color::GREEN, Gosu::Color::BLUE,
			Gosu::Color::YELLOW, Gosu::Color::FUCHSIA,
			Gosu::Color::CYAN ].sample
	end
end