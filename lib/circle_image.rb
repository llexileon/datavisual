class CircleImage < Gosu::Image

	attr_accessor :x, :y, :color

	def initialize(window, source, tileable)
		@color = color_picker
		super
	end

	def move!
	    @x ||= rand(1..400)
		@y ||= rand(1..400)

		@x += 2
		@y += 3

		@x %= 640
        @y %= 480
	end

	def color_picker
		@color = [  Gosu::Color::GRAY, Gosu::Color::BLACK,
			Gosu::Color::AQUA, Gosu::Color::RED,
			Gosu::Color::GREEN, Gosu::Color::BLUE,
			Gosu::Color::YELLOW, Gosu::Color::FUCHSIA,
			Gosu::Color::CYAN ].sample
	end
end