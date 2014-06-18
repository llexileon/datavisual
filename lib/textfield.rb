class TextField < Gosu::TextInput

  INACTIVE_COLOR  = 0xcc666666
  ACTIVE_COLOR    = 0xccff6666
  SELECTION_COLOR = 0xcc0000ff
  CARET_COLOR     = 0xffffffff
  PADDING = 5	

attr_reader :x, :y

	def initialize(window, font, x, y)
		super()
		@window = window
		@font = font
		@x, @y = x, y

		self.text = "Click to enter username"
	end

	def filter 
		text.upcase
	end

	def draw 

	

end