class TextField < Gosu::TextInput

  INACTIVE_COLOR  = Gosu::Color::rgb(76, 1, 152)
  ACTIVE_COLOR    = Gosu::Color::rgb(22, 178, 224)
  SELECTION_COLOR = 0xcc0000ff
  CARET_COLOR     = Gosu::Color::rgb(0, 255, 255)
  PADDING = 5	

	# attr_reader :x, :y,

	def initialize(window, font, x, y)
		@window = window
		@font = font
		@x, @y = x, y

		@text = "Click to enter username"
		super()
	end

	def x
		@x
	end

	def y
		@y
	end

	def filter(text)
		text.downcase
	end

	def draw 

	if @window.text_input == self then
      background_color = ACTIVE_COLOR
    else
      background_color = INACTIVE_COLOR
    end
	    
    @window.draw_quad(x - PADDING,         y - PADDING,          background_color,
                      x + width + 250, y - PADDING,          background_color,
                      x - PADDING,         y + height + PADDING, background_color,
                      x + width + 250, y + height + PADDING, background_color, 0)

	pos_x = x + @font.text_width(self.text[0...self.caret_pos])
    sel_x = x + @font.text_width(self.text[0...self.selection_start])  

    @window.draw_quad(sel_x, y,          SELECTION_COLOR,
                      pos_x, y,          SELECTION_COLOR,
                      sel_x, y + height, SELECTION_COLOR,
                      pos_x, y + height, SELECTION_COLOR, 0)


    if @window.text_input == self then
    	@window.draw_line(pos_x, y,          CARET_COLOR,
                          pos_x, y + height, CARET_COLOR, 0)
    end

    	@font.draw(self.text, x, y, 0)
  	end

  	def width
    	@font.text_width(self.text)
    end
  
    def height
    	@font.height
    end

    def under_point?(mouse_x, mouse_y)
    	mouse_x > x - PADDING and mouse_x < x + width + 250 and
    	mouse_y > y - PADDING and mouse_y < y + height + PADDING
    end    

	def move_caret(mouse_x)
	    1.upto(self.text.length) do |i|
	      if mouse_x < x + @font.text_width(text[0...i]) then
	        self.caret_pos = self.selection_start = i - 1;
	        return
	      end
	    end
	    self.caret_pos = self.selection_start = self.text.length
	end
end