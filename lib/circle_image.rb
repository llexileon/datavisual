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

	def move!
		@x += @speed_x
		@y += @speed_y 

		@x %= 600
        @y %= 900
	end

	def color_picker
		@color = [  Gosu::Color::GRAY, Gosu::Color::BLACK,
			Gosu::Color::AQUA, Gosu::Color::RED,
			Gosu::Color::GREEN, Gosu::Color::BLUE,
			Gosu::Color::YELLOW, Gosu::Color::FUCHSIA,
			Gosu::Color::CYAN ].sample
	end
end