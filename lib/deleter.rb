class Deleter #< Gosu::Image
	attr_accessor :task

	def initialize(window, task)
		@task = task
		@font = Gosu::Font.new(window, "assets/victor-pixel.ttf", 40)
	end

	def hitbox
  		hitbox_x = ((@task.x + 45).to_i..(@task.x + 245.to_i))
  		hitbox_y = ((@task.y + 85).to_i..(@task.y + 145).to_i)
  		{:x => hitbox_x, :y => hitbox_y}
  	end

  	def draw
  		if task.frozen
  		@font.draw("Completed", @task.x + 45, @task.y + 75, 150, 1, 1, Gosu::Color::GRAY)
  		end
  	end

end